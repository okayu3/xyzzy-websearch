xyzzy-websearch
===============

websearch-onthespot.l is a xyzzy editor plugin for easy web-search operation.
### ■websearch-onthespot.l とは？
> これは、xyzzy の拡張プラグインのひとつです。xyzzy をご存じない方は こちらをご覧ください。→  [xyzzyサイト](http://xyzzy-022.github.io/)。  

通常のテキスト編集中にweb検索を簡単に行う機能です。セレクション、リージョン、カーソル位置のワードのいずれかを自動的に判断して抽出し、これをクエリとして
	google や yahoo、wikipedia、英辞郎on the web、 xyzzy lispリファレンス などのキーワード検索webサービスに問い合わせます。
	結果はデフォルトのWebブラウザで表示されます。たとえば
```
	昨日はエイプリルフール だった。
```
というようなことを書いて、たとえば "プ"の位置にカーソルを合わせてこの機能を呼び出すと、「エイプリルフール」の検索結果が webブラウザに表示されます。
直接検索するパターンと、検索時にサーチエンジンを指定するパターンを選べます。

### ■動作環境
xyzzy-0.2.2.245/ 0.2.2.252 での実行を確認しました。

### ■インストール
1. websearch-onthespot.l を site-lisp に置いてください。
2. .xyzzy / sitelinit.l に次のように書いてください。
```
(require "websearch-onthespot")
(global-set-key '(#\C-c #\g) 'websearch-onthespot) ;;直接検索
(global-set-key '(#\C-c #\G) 'websearch-onthespot-with-confirm) ;;サーチエンジン指定
```

### ■使い方
任意の場所で C-c G と押下すると、

* ミニバッファに [Search Engines: ]と表示され、デフォルトのサーチエンジンが表示されます。
* google や wikipedia などを入力してEnterを押下するると指定したサーチエンジンで検索した結果がWebブラウザに表示されます。

任意の場所で C-c g と押下すると、

* 直近で "C-c G" で選択されたサーチエンジンで直接検索します。
* 直近のサーチエンジンがなければ "google"で検索します。

検索対象となるのは次のいずれかです。

1. 有効なセレクションがあれば、セレクションの内容で検索します。改行は スペースに変換されます。
2. 1以外の場合、リージョンが存在して、改行が含まれていなければ、 リージョンの内容で検索します。
3. 1,2以外の場合、カーソル位置のword (xyzzy の forward-word などで認識される区切りの範囲) で検索します。

### ■変更履歴
	[2014/04/03] この文書作成。リージョンマークが全くない場合にエラーになるバグの修正。
	[2014/04/02] 初版リリース

### ■由来
Emacs用のweb検索拡張 [search-web.el](https://github.com/tomoya/search-web.el/blob/master/search-web.el) に影響をうけました。

### ■License
MITライセンスです。

	Copyright (c) 2014 Okayu3
	Released under the MIT license
	http://opensource.org/licenses/mit-license.php

