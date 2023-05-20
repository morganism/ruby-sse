// Toggle visibility of sections based on user interaction
document.addEventListener("DOMContentLoaded", function() {
  const gaugesSection = document.querySelector(".gauges");
  const chartsSection = document.querySelector(".charts");
  const tablesSection = document.querySelector(".tables");
  const interactiveComponentsSection = document.querySelector(".interactive-components");

  const toggleVisibility = (section, toggleButton) => {
    section.style.display = section.style.display === "none" ? "block" : "none";
    toggleButton.textContent = section.style.display === "none" ? "Show" : "Hide";
  };

  const addToggleButton = (section, toggleButton) => {
    section.parentNode.insertBefore(toggleButton, section);
    toggleButton.addEventListener("click", () => {
      toggleVisibility(section, toggleButton);
    });
  };

  const createToggleButton = (section) => {
    const toggleButton = document.createElement("button");
    toggleButton.textContent = "Hide";
    addToggleButton(section, toggleButton);
  };

  createToggleButton(gaugesSection);
  createToggleButton(chartsSection);
  createToggleButton(tablesSection);
  createToggleButton(interactiveComponentsSection);
});

