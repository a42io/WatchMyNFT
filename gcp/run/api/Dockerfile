# Dockerfile Best Practice Multi Stage Build Pattern

# ----------
# build(tscを実行してjsを作る)用のstage
# ----------
FROM node:14-slim AS web

WORKDIR /web
COPY . .


RUN npm install && \
npm run type-check && \
npm run eslint:fix && \
npm run build

# ----------
# runtime用のstage
# 必要なファイルは下記のみ
#   dist/
#   node_modules/
#   package.json
#   package-lock.json
# ----------
FROM node:14-slim

# src下のtsファイルなど不要なものは含めない
COPY package*.json ./

# ランタイムに必要な依存パッケージのみインストールし、同時にnpmのcacheファイルを削除する
RUN npm install --production --cache /tmp/empty-cache && rm -rf /tmp/empty-cache

# --fromで前半で記述した　AS web と命名した中間イメージから必要なファイルのみ抽出する事ができる(distディレクトリにtsコンパイル結果であるjsファイルが出力されている)
COPY --from=web /web/dist ./dist

CMD [ "npm", "run", "up"]
