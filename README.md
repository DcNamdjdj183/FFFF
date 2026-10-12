# ELITE CLIENT

Unsigned iOS IPA. Kernel R/W chain for Free Fire. Writes localconfig.json into both Free Fire and Free Fire MAX containers by bundle ID.

## Structure
- `exploit/` and `kexploit/` — paste C sources/headers before build.
- ConfigManager walks `/var/mobile/Containers/Data/Application`, matches `MCMMetadataIdentifier`, writes `<container>/Documents/localconfig.json`.
- Logger feeds the Logs tab.
- KernelManager setters push values through ConfigManager.

## Build
Push to GitHub. Actions `build_ipa.yml` produces unsigned IPA on macos-latest.

## Boot
KernelAutoLoader → kernel attempt (3 retries) → fallback. Config load on UI appear.

## Credit
Developer: Dinh Duc Nam  
Contact: 0395109314 - 0332011756
