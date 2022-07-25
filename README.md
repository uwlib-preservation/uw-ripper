# uw-ripper
UW Lib Preservation's tool for batch CD-DA ripping. Harnesses DBPoweramp's CLI tools for controlling an Acronova Nimbie USB Plus in combination with the open source ripping software [CUETools](http://cue.tools/wiki/CUETools)

## Usage: ripcd [options]
    
    -o, --output-dir=val (Mandatory)
    -d, --discs=val (Mandatory)
    -b, --burst
    -s, --secure
    -p, --paranoid


## Output
* WAV file (per disc)
* CUE sheet (per disc)
* CUE Tools logfile (per disc)
* Rip log CSV (per batch)
* Console log (per batch)


## Dependencies
* DBPoweramp Batch Ripper (and associated drivers for Nimbie device)
* CUETools

## Installation and Set-up

Prior to use, you must have purchased and installed [dBPoweramp](https://www.dbpoweramp.com/) and all its associated [additions for batch ripping](https://www.dbpoweramp.com/batch-ripper.htm). You must also have installed all drivers for your [Nimbie device](https://disc.acronova.com/download/product/auto-blu-ray-duplicator-publisher-ripper-nimbie-usb-nb21/9.html).

This workflow and tool relies on the Nimbie control programs contained within the dBPoweramp batch ripping install, but will not actually be using dBPoweramp for the rips themselves. It will use the command line version of the CUERipper tool included in the CUETools suite of tools. CUETools must be [downloaded and installed](http://cue.tools/wiki/CUETools_Download) as well prior to use.

After all dependencies are installed, the configuration file (ripcd.config) must be edited in a text editor prior to use.

### Config File Set-up
* CLI_Tools_Path: this must be set to the path where the DBPoweramp CLI tools are installed. Typically this will be `C:/Program Files/dBpoweramp/BatchRipper/Loaders/Nimbie/`
* CueToolsPath: This must be the path to the CUE Tools CLI ripping program (CUETools.Ripper.Console.exe). If that program is on your default PATH then simply set this value to `CUETools.Ripper.Console.exe`
* LoadPath: The path to the CLI loading tool within the CLI Tools directory. Typically default value should not be changed.
* UnloadPath: The path to the CLI unloading tool within the CLI Tools directory. Typically default value should not be changed.
* Drive: This must be set to the drive letter of the Nimbie device.
