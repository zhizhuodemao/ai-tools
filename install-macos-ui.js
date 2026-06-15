ObjC.import("Foundation");

const app = Application.currentApplication();
app.includeStandardAdditions = true;

const pluginName = "boss-resume-agent-plugin";

function unwrap(value) {
  return ObjC.unwrap(value);
}

function shellQuote(value) {
  return "'" + String(value).replace(/'/g, "'\\''") + "'";
}

function exists(path) {
  return $.NSFileManager.defaultManager.fileExistsAtPath(path);
}

function readText(path) {
  if (!exists(path)) return null;
  const text = $.NSString.stringWithContentsOfFileEncodingError(
    path,
    $.NSUTF8StringEncoding,
    null
  );
  return text ? unwrap(text) : null;
}

function writeText(path, content) {
  const text = $.NSString.alloc.initWithUTF8String(content);
  text.writeToFileAtomicallyEncodingError(path, true, $.NSUTF8StringEncoding, null);
}

function ensureDir(path) {
  app.doShellScript("/bin/mkdir -p " + shellQuote(path));
}

function show(message, title) {
  app.displayDialog(message, {
    withTitle: title || "BOSS Resume Agent Installer",
    buttons: ["OK"],
    defaultButton: "OK"
  });
}

function main() {
  const bundlePath = unwrap($.NSBundle.mainBundle.bundlePath);
  const root = bundlePath.replace(/\/[^/]+\.app$/, "");
  const sourcePluginDir = root + "/plugins/" + pluginName;
  const home = unwrap($.NSHomeDirectory());
  const targetPluginParent = home + "/plugins";
  const targetPluginDir = targetPluginParent + "/" + pluginName;
  const marketplaceDir = home + "/.agents/plugins";
  const marketplaceFile = marketplaceDir + "/marketplace.json";

  if (!exists(sourcePluginDir)) {
    show(
      "找不到插件目录：\n" + sourcePluginDir + "\n\n请确认安装器还在解压后的 boss-resume-agent-codex-1.0.1 目录里。",
      "无法安装"
    );
    return;
  }

  app.displayDialog(
    "这会安装「BOSS 简历投递助手」到 Codex App 的个人插件目录。\n\n安装后请重启 Codex App，然后在 Plugins 里点击 Add to Codex。",
    {
      withTitle: "安装 BOSS 简历投递助手",
      buttons: ["取消", "安装"],
      defaultButton: "安装",
      cancelButton: "取消"
    }
  );

  ensureDir(targetPluginParent);
  ensureDir(marketplaceDir);
  app.doShellScript(
    "/bin/rm -rf " + shellQuote(targetPluginDir) +
      " && /bin/cp -R " + shellQuote(sourcePluginDir) + " " + shellQuote(targetPluginDir)
  );

  let payload = {
    name: "personal",
    interface: { displayName: "Personal" },
    plugins: []
  };

  const existing = readText(marketplaceFile);
  if (existing && existing.trim()) {
    try {
      payload = JSON.parse(existing);
    } catch (error) {
      show(
        "无法解析已有 marketplace 文件：\n" + marketplaceFile + "\n\n请先备份并修复这个 JSON 文件，再重新运行安装器。",
        "安装中止"
      );
      return;
    }
  }

  if (!payload || typeof payload !== "object" || Array.isArray(payload)) {
    payload = { name: "personal", interface: { displayName: "Personal" }, plugins: [] };
  }
  if (!payload.name) payload.name = "personal";
  if (!payload.interface || typeof payload.interface !== "object" || Array.isArray(payload.interface)) {
    payload.interface = {};
  }
  if (!payload.interface.displayName) payload.interface.displayName = "Personal";
  if (!Array.isArray(payload.plugins)) payload.plugins = [];

  const entry = {
    name: pluginName,
    source: {
      source: "local",
      path: "./plugins/" + pluginName
    },
    policy: {
      installation: "AVAILABLE",
      authentication: "ON_INSTALL"
    },
    category: "Productivity"
  };

  let replaced = false;
  payload.plugins = payload.plugins.map((item) => {
    if (item && item.name === pluginName) {
      replaced = true;
      return entry;
    }
    return item;
  });
  if (!replaced) payload.plugins.push(entry);

  writeText(marketplaceFile, JSON.stringify(payload, null, 2) + "\n");

  show(
    "安装完成。\n\n下一步：\n1. 重启 Codex App\n2. 打开 Plugins\n3. 找到「BOSS 简历投递助手」\n4. 点击 Add to Codex\n5. 新开线程使用",
    "安装完成"
  );
}

try {
  main();
} catch (error) {
  show(String(error), "安装失败");
}
