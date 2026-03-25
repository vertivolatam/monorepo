# Copyright (c) 2024 Vertivo Horticultura Urbana Vertical S.R.L.
# Cédula Jurídica 3-102-815230
# San Francisco, Heredia, Heredia, Republic of Costa Rica
# All Rights Reserved.
#
# This file is part of the Licensed Work under the Business Source License (BSL).
# You may obtain a copy of the License at ./LICENSE.md
# You may not use this file except in compliance with the License.

import json
import os
import sys
from pathlib import Path

try:
    import tkinter as tk
    from tkinter import ttk, messagebox, filedialog
except ImportError:
    tk = None

# Application constants
APP_NAME = "Vertivo Monitoring Orchestrator"
APP_VERSION = "1.0.0"
CONFIG_BASE_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "config")
DEFAULTS_CONFIG_DIR = os.path.join(CONFIG_BASE_DIR, "defaults")
CURRENT_CONFIG_DIR = os.path.join(CONFIG_BASE_DIR, "current")

# Available orchestrator modes
AVAILABLE_MODES = ["indoor", "outdoor", "soil", "environmental"]

def load_default_config(mode):
    """
    Load default configuration for a specific orchestrator mode.
    
    Args:
        mode (str): The orchestrator mode (indoor, outdoor, soil, environmental)
        
    Returns:
        dict: Default configuration parameters for the specified mode
    """
    if mode not in AVAILABLE_MODES:
        print(f"Error: Unknown mode '{mode}'.")
        sys.exit(1)
    
    default_config_path = os.path.join(DEFAULTS_CONFIG_DIR, f"{mode}.json")
    
    try:
        with open(default_config_path, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"Error: Default configuration file not found: {default_config_path}")
        sys.exit(1)
    except json.JSONDecodeError:
        print(f"Error: Invalid JSON format in default configuration file '{default_config_path}'.")
        sys.exit(1)

def load_mode_config(mode):
    """
    Load configuration for a specific orchestrator mode.
    First tries to load from current config, falls back to defaults if not found.
    
    Args:
        mode (str): The orchestrator mode (indoor, outdoor, soil, environmental)
        
    Returns:
        dict: Configuration parameters for the specified mode
    """
    if mode not in AVAILABLE_MODES:
        print(f"Error: Unknown mode '{mode}'.")
        sys.exit(1)
    
    # Try to load from current config first
    current_config_path = os.path.join(CURRENT_CONFIG_DIR, f"{mode}.json")
    
    try:
        with open(current_config_path, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        # Fall back to default config and create current config
        print(f"Current config not found, using defaults for mode '{mode}'")
        default_config = load_default_config(mode)
        
        # Create current config directory and copy default config
        os.makedirs(CURRENT_CONFIG_DIR, exist_ok=True)
        with open(current_config_path, 'w') as f:
            json.dump(default_config, f, indent=4)
        print(f"Created current configuration file: {current_config_path}")
        
        return default_config
    except json.JSONDecodeError:
        print(f"Error: Invalid JSON format in configuration file '{current_config_path}'.")
        print("Falling back to default configuration.")
        return load_default_config(mode)

def save_mode_config(mode, config):
    """
    Save configuration for a specific mode to the current config directory.
    
    Args:
        mode (str): The orchestrator mode
        config (dict): Configuration parameters
        
    Returns:
        bool: True if successful, False otherwise
    """
    if mode not in AVAILABLE_MODES:
        print(f"Error: Unknown mode '{mode}'.")
        return False
    
    try:
        # Ensure current config directory exists
        os.makedirs(CURRENT_CONFIG_DIR, exist_ok=True)
        
        current_config_path = os.path.join(CURRENT_CONFIG_DIR, f"{mode}.json")
        with open(current_config_path, 'w') as f:
            json.dump(config, f, indent=4)
        return True
    except Exception as e:
        print(f"Error saving configuration for mode '{mode}': {e}")
        return False

class ConfigEditorApp:
    def __init__(self, root):
        self.root = root
        self.root.title(f"{APP_NAME} - Configuration Editor")
        self.root.geometry("800x600")
        
        # Load all mode configurations
        self.config = {}
        for mode in AVAILABLE_MODES:
            self.config[mode] = load_mode_config(mode)
        
        self.create_widgets()
        
    def create_widgets(self):
        # Main frame
        main_frame = ttk.Frame(self.root, padding="10")
        main_frame.pack(fill=tk.BOTH, expand=True)
        
        # Menu bar
        menubar = tk.Menu(self.root)
        self.root.config(menu=menubar)
        
        file_menu = tk.Menu(menubar, tearoff=0)
        menubar.add_cascade(label="File", menu=file_menu)
        file_menu.add_command(label="Open Config", command=self.open_config)
        file_menu.add_command(label="Save Config", command=self.save_config)
        file_menu.add_command(label="Save Config As", command=self.save_config_as)
        file_menu.add_separator()
        file_menu.add_command(label="Exit", command=self.root.quit)
        
        # Mode menu
        mode_menu = tk.Menu(menubar, tearoff=0)
        menubar.add_cascade(label="Mode", menu=mode_menu)
        mode_menu.add_command(label="Indoor Urban Vertical Farming", 
                             command=lambda: self.switch_to_mode("indoor"))
        mode_menu.add_command(label="Outdoor Agricultural Farming", 
                             command=lambda: self.switch_to_mode("outdoor"))
        mode_menu.add_command(label="Soil Monitoring", 
                             command=lambda: self.switch_to_mode("soil"))
        mode_menu.add_command(label="Environmental Monitoring", 
                             command=lambda: self.switch_to_mode("environmental"))
        mode_menu.add_separator()
        mode_menu.add_command(label="Test Current Mode", command=self.test_selected_mode)
        
        help_menu = tk.Menu(menubar, tearoff=0)
        menubar.add_cascade(label="Help", menu=help_menu)
        help_menu.add_command(label="About", command=self.show_about)
        
        # Operation mode selector frame
        mode_frame = ttk.LabelFrame(main_frame, text="Operation Mode", padding=10)
        mode_frame.pack(fill=tk.X, padx=5, pady=5)
        
        ttk.Label(mode_frame, text="Select Active Mode:").pack(side=tk.LEFT, padx=5)
        
        self.active_mode_var = tk.StringVar(value="indoor")
        mode_dropdown = ttk.Combobox(mode_frame, textvariable=self.active_mode_var, 
                                   values=AVAILABLE_MODES, state="readonly", width=15)
        mode_dropdown.pack(side=tk.LEFT, padx=5)
        mode_dropdown.bind("<<ComboboxSelected>>", self.on_mode_change)
        
        # Test mode button
        test_button = ttk.Button(mode_frame, text="Test Selected Mode", 
                               command=self.test_selected_mode)
        test_button.pack(side=tk.RIGHT, padx=5)
        
        # Notebook for different modes
        self.notebook = ttk.Notebook(main_frame)
        self.notebook.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        
        # Create tabs for each mode
        self.create_mode_tab("indoor", "Indoor Urban Vertical Farming")
        self.create_mode_tab("outdoor", "Outdoor Agricultural Farming")
        self.create_mode_tab("soil", "Soil Monitoring")
        self.create_mode_tab("environmental", "Environmental Monitoring")
        
        # Status bar
        self.status_var = tk.StringVar()
        self.status_var.set(f"Active mode: {self.active_mode_var.get().title()} | Config from: {CURRENT_CONFIG_DIR}")
        status_bar = ttk.Label(main_frame, textvariable=self.status_var, relief=tk.SUNKEN, anchor=tk.W)
        status_bar.pack(side=tk.BOTTOM, fill=tk.X)
        
        # Buttons frame
        button_frame = ttk.Frame(main_frame)
        button_frame.pack(fill=tk.X, pady=10)
        
        save_button = ttk.Button(button_frame, text="Save", command=self.save_config)
        save_button.pack(side=tk.RIGHT, padx=5)
        
        reset_button = ttk.Button(button_frame, text="Reset to Defaults", command=self.reset_to_defaults)
        reset_button.pack(side=tk.RIGHT, padx=5)
    
    def create_mode_tab(self, mode, title):
        if mode not in self.config:
            self.config[mode] = load_default_config(mode)
        
        tab = ttk.Frame(self.notebook, padding=10)
        self.notebook.add(tab, text=title)
        
        # Create a canvas with scrollbar
        canvas = tk.Canvas(tab)
        scrollbar = ttk.Scrollbar(tab, orient="vertical", command=canvas.yview)
        scrollable_frame = ttk.Frame(canvas)
        
        scrollable_frame.bind(
            "<Configure>",
            lambda e: canvas.configure(scrollregion=canvas.bbox("all"))
        )
        
        canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
        canvas.configure(yscrollcommand=scrollbar.set)
        
        canvas.pack(side="left", fill="both", expand=True)
        scrollbar.pack(side="right", fill="y")
        
        # Add parameter entries
        row = 0
        self.entries = {}
        if mode not in self.entries:
            self.entries[mode] = {}
            
        for param, value in sorted(self.config[mode].items()):
            # Create label
            label = ttk.Label(scrollable_frame, text=param.replace("_", " ").title() + ":")
            label.grid(row=row, column=0, sticky=tk.W, padx=5, pady=5)
            
            # Create entry
            var = tk.StringVar(value=str(value))
            entry = ttk.Entry(scrollable_frame, textvariable=var, width=20)
            entry.grid(row=row, column=1, sticky=tk.W, padx=5, pady=5)
            
            # Store reference to entry variable
            self.entries[mode][param] = var
            
            row += 1
    
    def open_config(self):
        config_dir = filedialog.askdirectory(
            title="Select Configuration Directory",
            initialdir=CURRENT_CONFIG_DIR
        )
        
        if config_dir:
            try:
                # Load all mode configurations from the selected directory
                self.config = {}
                for mode in AVAILABLE_MODES:
                    mode_file = os.path.join(config_dir, f"{mode}.json")
                    if os.path.exists(mode_file):
                        with open(mode_file, 'r') as f:
                            self.config[mode] = json.load(f)
                    else:
                        self.config[mode] = load_default_config(mode)
                
                self.status_var.set(f"Config loaded from: {config_dir}")
                
                # Recreate tabs with new config
                for tab in self.notebook.tabs():
                    self.notebook.forget(tab)
                
                self.create_mode_tab("indoor", "Indoor Urban Vertical Farming")
                self.create_mode_tab("outdoor", "Outdoor Agricultural Farming")
                self.create_mode_tab("soil", "Soil Monitoring")
                self.create_mode_tab("environmental", "Environmental Monitoring")
                
                messagebox.showinfo("Success", "Configuration loaded successfully.")
            except Exception as e:
                messagebox.showerror("Error", f"Failed to load configuration: {e}")
    
    def save_config(self):
        # Update config from entries
        for mode in self.entries:
            for param, var in self.entries[mode].items():
                try:
                    # Convert to appropriate type
                    value = var.get()
                    if "." in value:
                        self.config[mode][param] = float(value)
                    else:
                        self.config[mode][param] = int(value)
                except ValueError:
                    messagebox.showerror("Error", f"Invalid value for {param}: {var.get()}")
                    return
        
        # Save each mode configuration to separate files
        success_count = 0
        for mode in self.config:
            if save_mode_config(mode, self.config[mode]):
                success_count += 1
        
        if success_count == len(self.config):
            self.status_var.set(f"Config saved to: {CURRENT_CONFIG_DIR}")
            messagebox.showinfo("Success", "Configuration saved successfully.")
        else:
            messagebox.showerror("Error", "Failed to save some configuration files.")
    
    def save_config_as(self):
        config_dir = filedialog.askdirectory(
            title="Select Directory to Save Configuration",
            initialdir=CURRENT_CONFIG_DIR
        )
        
        if config_dir:
            try:
                # Save each mode configuration to the selected directory
                success_count = 0
                for mode in self.config:
                    mode_file = os.path.join(config_dir, f"{mode}.json")
                    with open(mode_file, 'w') as f:
                        json.dump(self.config[mode], f, indent=4)
                    success_count += 1
                
                self.status_var.set(f"Config saved to: {config_dir}")
                messagebox.showinfo("Success", f"Configuration saved to {config_dir}")
            except Exception as e:
                messagebox.showerror("Error", f"Failed to save configuration: {e}")
    
    def reset_to_defaults(self):
        if messagebox.askyesno("Confirm Reset", "Are you sure you want to reset all settings to defaults?"):
            # Load default configurations
            self.config = {}
            for mode in AVAILABLE_MODES:
                self.config[mode] = load_default_config(mode)
            
            # Recreate tabs with default config
            for tab in self.notebook.tabs():
                self.notebook.forget(tab)
            
            self.create_mode_tab("indoor", "Indoor Urban Vertical Farming")
            self.create_mode_tab("outdoor", "Outdoor Agricultural Farming")
            self.create_mode_tab("soil", "Soil Monitoring")
            self.create_mode_tab("environmental", "Environmental Monitoring")
            
            self.status_var.set(f"Default configuration loaded (not saved)")
    
    def switch_to_mode(self, mode):
        """Switch to a specific operation mode."""
        self.active_mode_var.set(mode)
        self.on_mode_change()
    
    def on_mode_change(self, event=None):
        """Handle operation mode selection change."""
        selected_mode = self.active_mode_var.get()
        
        # Find and select the corresponding tab
        mode_tab_mapping = {
            "indoor": 0,
            "outdoor": 1, 
            "soil": 2,
            "environmental": 3
        }
        
        if selected_mode in mode_tab_mapping:
            self.notebook.select(mode_tab_mapping[selected_mode])
            self.status_var.set(f"Active mode: {selected_mode.title()} | Config from: {CURRENT_CONFIG_DIR}")
    
    def test_selected_mode(self):
        """Test the currently selected operation mode."""
        selected_mode = self.active_mode_var.get()
        
        try:
            # Save current config first
            self.save_config()
            
            # Show test dialog
            test_dialog = tk.Toplevel(self.root)
            test_dialog.title(f"Test {selected_mode.title()} Mode")
            test_dialog.geometry("400x300")
            test_dialog.transient(self.root)
            test_dialog.grab_set()
            
            # Test dialog content
            ttk.Label(test_dialog, text=f"Testing {selected_mode.title()} Mode", 
                     font=("Arial", 12, "bold")).pack(pady=10)
            
            # Command to run
            command_text = f"python -m src.main --orchestrator-mode {selected_mode} --debug"
            ttk.Label(test_dialog, text="Command to execute:").pack(pady=5)
            
            command_entry = tk.Text(test_dialog, height=2, width=50)
            command_entry.pack(pady=5, padx=10, fill=tk.X)
            command_entry.insert(tk.END, command_text)
            command_entry.config(state=tk.DISABLED)
            
            # Instructions
            instructions = tk.Text(test_dialog, height=8, width=50, wrap=tk.WORD)
            instructions.pack(pady=5, padx=10, fill=tk.BOTH, expand=True)
            instructions.insert(tk.END, 
                f"To test the {selected_mode} mode:\n\n"
                f"1. Open a terminal/command prompt\n"
                f"2. Navigate to the project directory\n"
                f"3. Run the command shown above\n"
                f"4. Check the output for any errors\n\n"
                f"Note: Make sure all required sensors are connected "
                f"and the orchestrator dependencies are installed.")
            instructions.config(state=tk.DISABLED)
            
            # Close button
            ttk.Button(test_dialog, text="Close", 
                      command=test_dialog.destroy).pack(pady=10)
            
        except Exception as e:
            messagebox.showerror("Test Error", f"Failed to prepare test: {e}")
    
    def show_about(self):
        messagebox.showinfo(
            "About",
            f"{APP_NAME} v{APP_VERSION}\n\n"
            "© 2024 Vertivo Horticultura Urbana Vertical S.R.L.\n"
            "Cédula Jurídica 3-102-815230\n"
            "San Francisco, Heredia, Heredia, Republic of Costa Rica\n"
            "All Rights Reserved."
        )

def main():
    root = tk.Tk()
    app = ConfigEditorApp(root)
    root.mainloop()

if __name__ == "__main__":
    main()