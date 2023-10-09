# uw-ripper
UW Lib Preservation's tool for batch CD-DA ripping. Harnesses DBPoweramp's CLI tools for controlling an Acronova Nimbie USB Plus in combination with the open source ripping software [CUETools](http://cue.tools/wiki/CUETools)

### Usage: ripcd.rb [options]
    Mandatory options
    `-o`, --output-dir=val
    `-d`, --discs=val
    Rip mode options
    `-b`, --burst
    `-s`, --secure (default)
    `-p`, --paranoid


### Output
* WAV file (per disc)
* CUE sheet (per disc)
* CUE Tools logfile (per disc)
* Console log (per disc)
* Rip log CSV (per batch)


### Dependencies
* dBPoweramp Batch Ripper (and associated drivers for Nimbie device)
* CUETools

### Rip Modes (from CUETools [documentation](http://cue.tools/wiki/CUERipper_Settings))
    Burst mode = Reads section once. If the drive reports C2 errors, then error correction begins and up to 15 more read retries are done.
    
    Secure mode = Reads section once, then one retry. If results differ or the drive reports C2 errors, then error correction begins and up to 30 more full or partial read retries are done for that section.
    
    Paranoid mode = Reads section once, then two retries. If results differ or the drive reports C2 errors then error correction begins and up to 61 more full or partial read retries are done for that section.

## Installation and Set-up

Prior to use, you must have purchased and installed [dBPoweramp](https://www.dbpoweramp.com/) and all its associated [additions for batch ripping](https://www.dbpoweramp.com/batch-ripper.htm). You must also have installed all drivers for your [Nimbie device](https://disc.acronova.com/download/product/auto-blu-ray-duplicator-publisher-ripper-nimbie-usb-nb21/9.html).

The 'Batch Ripper Configuration' app must be run post installation and your Nimbie device must be configured to use 'Nimbie' as its loading method. For more detailed instructions see [this example](https://github.com/KBNLresearch/iromlab/blob/master/doc/setupDbpoweramp.md#drive-configuration) from the IROMLAB documentation. (Note, you do not have to follow any of the steps in the General Configuration section on that page as our UW tool does not actually use dBPoweramp for the ripping of the CDs).

This workflow and tool relies on the Nimbie control programs contained within the dBPoweramp batch ripping install, but will not actually be using dBPoweramp for the rips themselves. It will use the command line version of the CUERipper tool included in the CUETools suite of tools. CUETools must be [downloaded and installed](http://cue.tools/wiki/CUETools_Download) as well prior to use. The ripping script itself is written in [Ruby](https://rubyinstaller.org/), so that will also need to be installed if not already present.

After all dependencies are installed, the configuration file (ripcd.config) must be edited in a text editor prior to use.

### Config File Set-up
* CLI_Tools_Path: this must be set to the path where the DBPoweramp CLI tools are installed. Typically this will be `C:/Program Files/dBpoweramp/BatchRipper/Loaders/Nimbie/`
* CueToolsPath: This must be the path to the CUE Tools CLI ripping program (CUETools.Ripper.Console.exe). If that program is on your default PATH then simply set this value to `CUETools.Ripper.Console.exe`
* LoadPath: The path to the CLI loading tool within the CLI Tools directory. Typically default value should not be changed from default.
* UnloadPath: The path to the CLI unloading tool within the CLI Tools directory. Typically default value should not be changed from default.
* Drive: This must be set to the drive letter of the Nimbie device.


## Use and Workflow
* A current known quirk of the workflow is that CUETools will always attempt to search its remote database for CD Metadata. This might be desirable if using this tool to preserve commercial CDs, but can result in innacurate metadata being matched to non-commercial CD-Rs. To avoid this, it is recommended to disable the internet connection for the transfer computer during ripping.
* To start a batch run the command ripcd.rb with the appropriate flags. The `-o` flag must be used followed by the path to your desired batch output directory. The `-d` flag must be used followed by the number of discs in the batch to be ripped. The rip mode options can be set with the desired flag, with the default rip mode being `Secure`.
* After batch ripping is complete, files should be renamed with included `rename-waves.rb` script. This script requires two inputs - a text file containing the list of names for discs in the same order as disc ripping, and a target directory containing the WAV files to be renamed. 
Usage: rename-waves.rb
    `-t, --target=val`
    `-n, --name-file=val`
  
Example: rename-waves.rb -t [directory of WAV files] -n [my-name-list.txt]

* Post renaming, files should have BWF metadata embedded in them adhering to [UW's usual requirements for embedded metadata](https://staff.lib.uw.edu/operations/preservation/for-all-staff/media-preservation/bwf-metadata-requirements). Note that the 'Coding History' field will only involve one line as there is no analog component to the migration process.
* After BWF metadata is embedded, the WAV/CUE pairs may be batch converted to FLAC/CUE if desired. This can be accomplished with the [bwf2flac](https://github.com/uwlib-preservation/uwmediascripts/blob/master/bwf2flac.rb) script in the general [uwmediascripts](https://github.com/uwlib-preservation/uwmediascripts/tree/master) repository. This will create a FLAC/CUE pair that contains both crosswalks the BWF metadata to metadata tags in the FLAC file as well as embeds the original BWF metadata to ensure the reversibility of the process.

