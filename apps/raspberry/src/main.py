# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

import argparse
import sys
from pathlib import Path

# Import configuration module
from src.config import load_mode_config

# Import orchestrators
from src.orchestrators.agronomic.indoor_urban_vertical_farming.orchestrator import IndoorUrbanVerticalFarmingOrchestrator
from src.orchestrators.agronomic.outdoor_agricultural_farming.orchestrator import OutdoorAgriculturalFarmingOrchestrator
from src.orchestrators.agronomic.soil.orchestrator import SoilOrchestrator
from src.orchestrators.environmental.orchestrator import EnvironmentalOrchestrator

# Import simulation
from src.simulation.simulator import Simulator
from src.simulation.scenarios import list_scenarios

def create_orchestrator(mode, mode_config):
    """
    Create and return the appropriate orchestrator based on the mode.
    
    Args:
        mode (str): Operation mode
        mode_config (dict): Configuration parameters for the specific mode
        
    Returns:
        object: Initialized orchestrator
    """
    
    if mode == "indoor":
        """
        Indoor Urban Vertical Farming Orchestrator Configuration
        ======================================================
        
        This orchestrator manages hydroponic systems with comprehensive monitoring of:
        
        Environmental Parameters:
        - CO2 concentration (ppm): Controls photosynthesis efficiency
        - Humidity (%): Maintains optimal transpiration rates
        
        Nutrient Solution Parameters:
        - DO (Dissolved Oxygen, mg/L): Ensures root health and nutrient uptake
        - EC (Electrical Conductivity, µS/cm): Measures total nutrient concentration
        - ORP (Oxidation-Reduction Potential, mV): Indicates water quality and sterilization
        - pH: Controls nutrient availability and uptake efficiency
        - TDS (Total Dissolved Solids, mg/L): Alternative nutrient concentration measurement
        - Temperature (°C): Affects nutrient solubility and root metabolism
        
        All parameters use lower/upper bounds for automated control and alerting.
        """
        return IndoorUrbanVerticalFarmingOrchestrator(
            co2_input_lower_bound=mode_config.get("co2_input_lower_bound"),
            co2_input_upper_bound=mode_config.get("co2_input_upper_bound"),
            humidity_input_lower_bound=mode_config.get("humidity_input_lower_bound"),
            humidity_input_upper_bound=mode_config.get("humidity_input_upper_bound"),
            nutrient_solution_do_input_lower_bound=mode_config.get("nutrient_solution_do_input_lower_bound"),
            nutrient_solution_do_input_upper_bound=mode_config.get("nutrient_solution_do_input_upper_bound"),
            nutrient_solution_ec_input_lower_bound=mode_config.get("nutrient_solution_ec_input_lower_bound"),
            nutrient_solution_ec_input_upper_bound=mode_config.get("nutrient_solution_ec_input_upper_bound"),
            nutrient_solution_orp_input_lower_bound=mode_config.get("nutrient_solution_orp_input_lower_bound"),
            nutrient_solution_orp_input_upper_bound=mode_config.get("nutrient_solution_orp_input_upper_bound"),
            nutrient_solution_ph_input_lower_bound=mode_config.get("nutrient_solution_ph_input_lower_bound"),
            nutrient_solution_ph_input_upper_bound=mode_config.get("nutrient_solution_ph_input_upper_bound"),
            nutrient_solution_tds_input_lower_bound=mode_config.get("nutrient_solution_tds_input_lower_bound"),
            nutrient_solution_tds_input_upper_bound=mode_config.get("nutrient_solution_tds_input_upper_bound"),
            nutrient_solution_temperature_input_lower_bound=mode_config.get("nutrient_solution_temperature_input_lower_bound"),
            nutrient_solution_temperature_input_upper_bound=mode_config.get("nutrient_solution_temperature_input_upper_bound")
        )
    elif mode == "outdoor":
        return OutdoorAgriculturalFarmingOrchestrator(**mode_config)
    elif mode == "soil":
        return SoilOrchestrator(**mode_config)
    elif mode == "environmental":
        return EnvironmentalOrchestrator(**mode_config)
    else:
        print(f"Error: Unknown operation mode '{mode}'.")
        sys.exit(1)

def main():
    """
    Main function to parse arguments and run the appropriate orchestrator.
    """
    parser = argparse.ArgumentParser(description="Monitoring Orchestrator System")
    parser.add_argument("--orchestrator-mode", choices=["indoor", "outdoor", "soil", "environmental"],
                        required=True, help="Orchestrator operation mode")
    parser.add_argument("--config-override",
                        help="Optional path to override configuration file for the selected mode")
    parser.add_argument("--debug", action="store_true",
                        help="Enable debug output")

    # Simulation arguments
    parser.add_argument("--simulate", action="store_true",
                        help="Run with simulated sensors (no I2C hardware required)")
    parser.add_argument("--scenario", default="normal",
                        help="Simulation scenario (use --list-scenarios to see options)")
    parser.add_argument("--list-scenarios", action="store_true",
                        help="List available simulation scenarios and exit")
    parser.add_argument("--sim-interval", type=int, default=30,
                        help="MQTT publish interval in seconds for simulation (default: 30)")

    args = parser.parse_args()

    # List scenarios and exit
    if args.list_scenarios:
        print("Available simulation scenarios:\n")
        for name, description in list_scenarios():
            print(f"  {name:<25} {description}")
        print(f"\nUsage: python3 -m src.main --orchestrator-mode indoor --simulate --scenario <name>")
        sys.exit(0)

    # Simulation mode
    if args.simulate:
        import logging
        logging.basicConfig(
            level=logging.DEBUG if args.debug else logging.INFO,
            format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
        )

        # Load config for bounds
        if args.config_override:
            import json
            with open(args.config_override, 'r') as f:
                mode_config = json.load(f)
        else:
            mode_config = load_mode_config(args.orchestrator_mode)

        sim = Simulator(
            scenario=args.scenario,
            mode_config=mode_config,
            mqtt_publish_interval=args.sim_interval,
            debug=args.debug,
        )
        sim.start()
        sys.exit(0)

    # Load configuration for the specific mode
    if args.config_override:
        # Load from override file
        try:
            import json
            with open(args.config_override, 'r') as f:
                mode_config = json.load(f)
            print(f"Using configuration override: {args.config_override}")
        except Exception as e:
            print(f"Error loading config override: {e}")
            sys.exit(1)
    else:
        # Load from standard config system
        mode_config = load_mode_config(args.orchestrator_mode)

    # Create orchestrator based on mode
    orchestrator = create_orchestrator(args.orchestrator_mode, mode_config)

    # Read sensor data
    orchestrator.read_sensors()

    # Output results
    if args.debug:
        orchestrator.debug_print()
    else:
        print(orchestrator.json_serialize_status())

if __name__ == "__main__":
    main()