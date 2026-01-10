<div align="center">
  <img
    alt="header"
    src="https://capsule-render.vercel.app/api?type=soft&height=300&color=0:7EBAE4,100:5277C3&text=~/.dotfiles%20with%20Nix%20and%20chezmoi&fontColor=e8effc&fontSize=36&desc=for%20macOS&fontAlignY=48&descAlignY=66&textBg=false&descSize=26"
  />
</div>

---

<div align="center">
  <img alt="nix" src="https://img.shields.io/badge/nix-5277C3?style=for-the-badge&logo=nixos&logoColor=white"/> <img alt="macOS" src="https://img.shields.io/badge/macOS-222222?style=for-the-badge&logo=apple&logoColor=white"/>
</div>

## 設定

1. ホスト名の設定と`CLT`のインストールから`ssh`のキー生成もしくは復元  
```sh
# 設定と確認
sudo scutil --set LocalHostName <hostKey>
scutil --get LocalHostName

# インストールと確認
xcode-select --install
xcode-select -p
```
> [!IMPORTANT]
> `hostKey`は`nix/hosts/darwin/<hostKey>`のフォルダ名と一致してる必要があります  

2. `chezmoi`の初期化をしてドットファイルの展開  
```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <repository-url>
```

3. セットアップ  
```sh
cd ~/.local/share/chezmoi/scripts

# 確認
./setup.sh --dry-run
# 実行
./setup.sh
```
