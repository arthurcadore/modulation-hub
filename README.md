# Analog and Digital Signals Processing Repository 
### Telecom Eng. - Digital Processing Signals and Wireless System Communications

#### This repository is dedicated to matlab files (processed by free [octave kernel for python](https://github.com/Calysto/octave_kernel)) and configurated by [jupyter notebook](https://jupyter.org/) annotation. 

![APC 5A 90 Irradiation](https://github.com/arthurcadore/antennaModelling/blob/main/HFSS/pictures/APC%205A%2090.png)
---

### How to Use the Repository:

To use the repository is recomended to create a new `devcontainer` to compile the processing signal files and change the default parameters for what you need. 

In the `.devcontainer/devcontainer.json`, you'll find the configuration for extencions and other paramters, is recomended to change/add the extensions before starts the devcontainer application.

```
{
	"name": "Containerized Octave",
	"build": {
		"dockerfile": "Dockerfile"
	},
	"customizations": {
		"vscode": {
			"extensions": [
				"ms-python.python",
				"ms-toolsai.jupyter",
				"toasty-technologies.octave",
				"GitHub.copilot",
				"dracula-theme.theme-dracula"
			]
		}
	}
}
```

Once the devcontainer is opened, you can explore the collection of signal modulation, multiplexing and filtering files. You'll find the raw matlab code, ilustrations (plots) about the signal processing, and processing annotations made in markdown sections. So change the parameters for your custom cenario and after execute the `full-rebuild` for the archive. 

For new archives, make sure to use the extension `.ipynb` so the jupyter annotation can work as well. 

### To clone all repository you can use the command below:

```
git clone https://github.com/arthurcadore/modulation-hub
```
---
