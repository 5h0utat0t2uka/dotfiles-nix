# dotfiles-nix

macOS（単一プロファイル）向けの nix-darwin + home-manager + chezmoi 構成。

- 既存環境を保持したまま、新しい APFS ボリュームにクリーン構築
- プロファイル切替は行わない（single profile）

---

## 対象

- macOS（Apple Silicon / Intel 両対応）
- 新APFSボリュームでの初回セットアップ
- CLI は Nix、GUI は Homebrew cask、dotfiles は chezmoi

---

## 初回セットアップ（新ボリューム）

### 1. Xcode Command Line Tools

実行:

    xcode-select --install

### 2. chezmoi 実行

実行:

    chezmoi init --apply git@github.com:5h0utat0t2uka/dotfiles-nix.git

Nix が未導入の場合、chezmoi の script が自動で Nix をインストールする。  
続けて nix-darwin（darwin-rebuild）が flake 経由で実行される。

---

## 事前確認（重要）

### LocalHostName

確認:

    scutil --get LocalHostName

- flake.nix の hostname と一致させること

### ユーザー名

- 新ボリューム作成時に作った macOS ユーザー名
- flake.nix の username と一致させること

### CPU アーキテクチャ

- Apple Silicon: aarch64-darwin
- Intel: x86_64-darwin

---

## 運用

### 設定変更の反映

    chezmoi apply

### Nix 世代の整理（必要時）

    nix-collect-garbage -d

---

## 設計方針

- CLI: Nix（nix-darwin / home-manager）
- GUI: Homebrew cask（nix-darwin 管理）
- dotfiles: chezmoi
- ghq root: ~/Development/repositories
- XDG Base Directory を前提に構成
- ZDOTDIR を使用（.zshenv で定義）

---

## 注意事項

- home.stateVersion / system.stateVersion は互換性固定用  
  一度決めたら原則変更しない
- flake.lock は必ず commit する
- ローカル差分や秘密情報は .chezmoidata.local.yaml を使用する
