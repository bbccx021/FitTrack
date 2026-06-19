# FitTrack — Web 版

這是 FitTrack(React Native / Expo)健身紀錄 app 的**網頁靜態匯出版**,可直接放上 GitHub Pages 供人用瀏覽器連線使用。資料存在使用者瀏覽器的 localStorage(無後端、無需登入)。

> 由 `expo export -p web` 產生。原始 app 在 `../fittrack-app`。

---

## 重要:資源路徑(baseUrl)

這份匯出已把資源路徑寫死成 **`/fittrack`**,也就是預期網址為:

```
https://<你的帳號>.github.io/fittrack/
```

**所以 GitHub 倉庫(repo)必須命名為 `fittrack`。**
若你想用別的 repo 名稱,請改用其他名稱重建(見最後一節),否則圖片與程式會 404。

---

## 部署到 GitHub Pages(專案頁)

1. 在 GitHub 建立一個**名為 `fittrack`** 的 repo(Public)。
2. 把**這個資料夾裡的所有內容**(含 `.nojekyll`、`_expo/`、`assets/`、`index.html`…)放到 repo 根目錄並 push。
   - 用網頁拖拉上傳也可以,但 `.nojekyll` 是隱藏檔,建議用 git 指令以免漏掉:
     ```bash
     cd fittrack-web
     git init -b main
     git add -A
     git commit -m "Add FitTrack web build"
     git remote add origin https://github.com/<你的帳號>/fittrack.git
     git push -u origin main
     ```
3. repo → **Settings → Pages → Build and deployment → Deploy from a branch**,選 `main` 分支、`/ (root)` 資料夾,Save。
4. 等 1–2 分鐘,開啟 **https://<你的帳號>.github.io/fittrack/** 即可使用。

### 兩個關鍵檔案(別刪)
- **`.nojekyll`** — 阻止 GitHub Pages 的 Jekyll 把 `_expo/` 這種底線開頭的資料夾過濾掉(沒有它整站會壞)。
- **`404.html`** — SPA 深層連結 fallback;直接開子頁面時讓路由在前端接手。

---

## 換成別的 repo 名稱

資源路徑必須跟網址子路徑一致。若 repo 不叫 `fittrack`,在專案根目錄用重建腳本重新產生:

```powershell
# 例如 repo 名為 my-gym
.\fittrack-web\rebuild-web.ps1 -Repo my-gym
```

腳本會把 `fittrack-app/app.json` 的 `experiments.baseUrl` 設成 `/my-gym`、重新 `expo export`,並把產物覆蓋回 `fittrack-web/`。之後網址就是 `https://<你的帳號>.github.io/my-gym/`。

> 若是「使用者頁」(repo 名為 `<帳號>.github.io`,根路徑),baseUrl 用 `/`:`.\fittrack-web\rebuild-web.ps1 -Repo ""`。
