# dotfiles-nix

- CLI: Nix(home-manager) で管理
- GUI: Homebrew(cask) で管理
- 最終的に nix-darwin の homebrew モジュールへ移管し、宣言外は削除できるようにする

```
dotfiles-nix/
├── README.md
├── flake.nix
├── nix-config/
│   └── darwin/
│       ├── default.nix
│       └── home.nix
├── scripts/
│   ├── user.sh
│   └── darwin.sh
├── config/
│   ├── identity.nix          # 自動生成（git管理しない）
│   └── homebrew-casks.txt
├── home/
│   ├── dot_zshenv
│   └── dot_config/
│       ├── git/
│       │   └── config
│       └── zsh/
│           └── zshrc
├── .chezmoidata.yaml
├── .chezmoi.toml.tmpl
├── .chezmoiignore
└── .gitignore
```

## 手順（段階的）
Phase A: 安全に立ち上げ（Homebrewは手動 + Brewfileはまだ使わない/cleanupしない）
Phase B: Nix(home-manager) を導入（CLIのみ）
Phase C: nix-darwin を導入（任意・最後）
Phase D: Homebrew管理を nix-darwin に移管
Phase E: cleanup を有効化（宣言外の削除）

詳細は scripts のコメント参照。
