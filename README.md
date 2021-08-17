<p align="center">
<img src="./bmaude.jpg">
</p>

# BMaude
BMaude is a verification tool for B specifications written in the Abstract Machine Notation. The tool is implemented in the [Maude](http://maude.cs.uiuc.edu) language, by Christiano Braga (<http://www.ic.uff.br/~cbraga>).

## System requirements
* This version of BMaude requires Maude Alpha 115 which is distributed
  together with BMaude. 
* [iTerm 2](https://www.iterm2.com) on [macOS](https://www.apple.com/br/macos/) produces a nicer experience.

## Installing the tool

- Simply copy the files to your prefered folder and edit bmaude shell
  script to update the shell variables accordingly.

- Update `BMAUDE_DIR` and `MAUDE` variable in the `bmaude` shell
  script to represent the proper directory where BMaude is installed
  and which Maude executable you will use, either darwin or linux..

- Make sure `$MAUDE` and `$BMAUDE_DIR/imgcat` are flagged as
  executable files. 

## Running the tool

Type `./bmaude file.bmaude` on the command line. 

For a demo, just run `./bmaude demo`.

### Acknowledgements

Narciso Martí-Oliet, Maurício Pires, Anamaria Moreira and David Deharbe gave invaluable contributions to this project.

<div>Logo made with <a href="https://www.designevo.com/" title="Free Online Logo Maker">DesignEvo</a>.</div>



