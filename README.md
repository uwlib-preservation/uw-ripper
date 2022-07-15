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

## Config File Set-up
* CLI_Tools_Path: this must be set to the path where the DBPoweramp CLI tools are installed. Typically this will be `C:/Program Files/dBpoweramp/BatchRipper/Loaders/Nimbie/`
* CueToolsPath: This must be the path to the CUE Tools CLI ripping program (CUETools.Ripper.Console.exe). If that program is on your default PATH then simply set this value to `CUETools.Ripper.Console.exe`
* LoadPath: The path to the CLI loading tool within the CLI Tools directory. Typically default value should not be changed.
* UnloadPath: The path to the CLI unloading tool within the CLI Tools directory. Typically default value should not be changed.
* Drive: This must be set to the drive letter of the Nimbie device.
