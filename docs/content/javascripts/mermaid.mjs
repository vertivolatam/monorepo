import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";

mermaid.initialize({
  startOnLoad: false,
  theme: "base",
  securityLevel: "loose",
  flowchart: {
    useMaxWidth: false,
  },
  sequenceDiagram: {
    useMaxWidth: false,
  },
  gantt: {
    useMaxWidth: false,
  },
  themeVariables: {
    darkMode: true,
    background: "#1a1a2e",
    primaryColor: "#772583",
    primaryTextColor: "#e0e0e0",
    primaryBorderColor: "#A85AB3",
    lineColor: "#e0e0e0",
    secondaryColor: "#CEDC00",
    tertiaryColor: "#5E7E29",
  },
});

document.addEventListener("DOMContentLoaded", () => {
  mermaid.run({
    querySelector: ".mermaid",
  });

  document.querySelectorAll(".mermaid svg").forEach((svg) => {
    svg.style.cursor = "grab";
    svg.style.maxWidth = "100%";
    svg.style.height = "auto";

    let isDragging = false;
    let startX, startY, translateX = 0, translateY = 0;
    let scale = 1;

    svg.addEventListener("mousedown", (e) => {
      isDragging = true;
      startX = e.clientX - translateX;
      startY = e.clientY - translateY;
      svg.style.cursor = "grabbing";
    });

    document.addEventListener("mouseup", () => {
      isDragging = false;
      svg.style.cursor = "grab";
    });

    document.addEventListener("mousemove", (e) => {
      if (!isDragging) return;
      translateX = e.clientX - startX;
      translateY = e.clientY - startY;
      svg.style.transform = `translate(${translateX}px, ${translateY}px) scale(${scale})`;
      svg.style.transition = "none";
    });

    svg.addEventListener("wheel", (e) => {
      e.preventDefault();
      const delta = e.deltaY > 0 ? 0.9 : 1.1;
      scale = Math.min(Math.max(0.5, scale * delta), 3);
      svg.style.transform = `translate(${translateX}px, ${translateY}px) scale(${scale})`;
      svg.style.transition = "transform 0.1s ease-out";
    });

    svg.addEventListener("dblclick", () => {
      scale = 1;
      translateX = 0;
      translateY = 0;
      svg.style.transform = `translate(0, 0) scale(1)`;
      svg.style.transition = "transform 0.3s ease";
    });
  });
});
