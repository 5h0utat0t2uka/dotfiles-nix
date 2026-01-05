{ ... }:

{
  imports = [
    ../../../modules/darwin/system.nix
    ../../../modules/darwin/homebrew.nix

    # home-manager は flake.nix 側で統合している（home-manager.users の import も flake で実施）
    # もし将来 “ホスト入口側に寄せたい” なら設計変更する
  ];
}
