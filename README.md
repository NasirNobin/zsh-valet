# ZSH Valet
This zsh plugin will read `.valetphprc` from the project root and will switch to that PHP version automatically real time

<details>
<summary>Here's a quick video demonstration </summary>

https://user-images.githubusercontent.com/13833460/158659897-f6376d8d-8dfa-4e2d-a82a-82bb0aafb009.mp4
</details>

## Install
1. Clone this repository in oh-my-zsh's plugins directory:
```bash
git clone https://github.com/NasirNobin/zsh-valet ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-valet
```
2. Activate the plugin in `~/.zshrc`:
```
plugins=( [plugins...] zsh-valet)
```
3. Create a file named `.valetphprc` in your project directory with following project's PHP version. Example:  
```bash
php@8.1
```
4. Optionally, You can define a default PHP version on your `.zshrc`. This will be used to reset PHP Binary when you exit a project directory. (Make sure to put before the `plugins=( [plugins...] zsh-valet)` block)
```bash
VALETPHPRC_DEFAULT_PHP=php@8.0
```
5. Restart zsh (such as by opening a new instance of your terminal emulator). Now when you cd into your project directory. It should automatically swap to .valetphprc defined PHP binary for that session. 


## Do not show PHP Version
If you don't want to show the PHP version change add this to your ` ~/.zshrc`. 
```bash
export VALETPHPRC_DO_NOT_SHOW_PHP_VERSION=1
```
