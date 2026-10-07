/* WebMCP — expose this site's key actions as browser tools.
   https://webmachinelearning.github.io/webmcp/
   Registration is guarded: browsers without the API simply skip it. */
(function () {
  "use strict";

  if (typeof navigator === "undefined" || !navigator.modelContext) {
    return;
  }

  var controller = new AbortController();

  function register(tool) {
    try {
      navigator.modelContext.registerTool(tool, { signal: controller.signal });
    } catch (err) {
      try {
        navigator.modelContext.registerTool(tool);
      } catch (ignored) {
        /* API shape not supported in this build — nothing to register. */
      }
    }
  }

  register({
    name: "get_site_index",
    description:
      "Return the anhkhoakz.dev llms.txt site index: the site's title, summary and the important pages with links.",
    inputSchema: {
      type: "object",
      properties: {},
      additionalProperties: false
    },
    execute: async function () {
      var response = await fetch("/llms.txt", {
        signal: controller.signal
      });
      if (!response.ok) {
        throw new Error("llms.txt returned " + response.status);
      }
      return await response.text();
    }
  });

  register({
    name: "get_recent_posts",
    description:
      "Return the ten most recent posts on anhkhoakz.dev as JSON: title, canonical URL and publication date.",
    inputSchema: {
      type: "object",
      properties: {},
      additionalProperties: false
    },
    execute: async function () {
      var response = await fetch("/atom.xml", {
        signal: controller.signal
      });
      if (!response.ok) {
        throw new Error("atom.xml returned " + response.status);
      }
      var doc = new DOMParser().parseFromString(
        await response.text(),
        "application/atom+xml"
      );
      var entries = Array.prototype.slice
        .call(doc.getElementsByTagName("entry"))
        .slice(0, 10)
        .map(function (entry) {
          var link = entry.getElementsByTagName("link")[0];
          return {
            title: (entry.getElementsByTagName("title")[0] || {}).textContent || "",
            url: link ? link.getAttribute("href") : "",
            updated: (entry.getElementsByTagName("updated")[0] || {}).textContent || ""
          };
        });
      return JSON.stringify(entries, null, 2);
    }
  });

  register({
    name: "navigate_to",
    description:
      "Navigate the open page to another path on anhkhoakz.dev, for example /blog/ or /privacy/. Only same-origin paths are allowed.",
    inputSchema: {
      type: "object",
      properties: {
        path: {
          type: "string",
          description: "Same-origin path beginning with /"
        }
      },
      required: ["path"],
      additionalProperties: false
    },
    execute: async function (args) {
      var path = args && typeof args.path === "string" ? args.path : "";
      if (path.charAt(0) !== "/" || path.indexOf("//") === 0) {
        throw new Error("path must be a same-origin path beginning with /");
      }
      window.location.assign(path);
      return "Navigating to " + path;
    }
  });

  /* Unregister every tool when the page goes away. */
  window.addEventListener("pagehide", function () {
    controller.abort();
  });
})();
