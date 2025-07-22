local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt
local c = ls.choice_node
local f = ls.function_node

vim.keymap.set({ "i", "s" }, "<C-k>", function ()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-j>", function ()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-n>", function ()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end)

ls.add_snippets("lua", {
    s("if", {
        t('if '),
        i(1, "true"),
    t(' then '),
        i(2),
        t(' end')
    }),

    s("ls", fmt(
    [[
    ls.add_snippets("{}", {{
        {}
    }})
    ]], {
        i(1, "lua"), i(2, "hello")
    })),
})

ls.add_snippets("cs", {
    s("pubtest",
    fmt([[ public {} {} {{ get; set; }} ]],
    {
        c(1, {
            t("string"),
            t("bool"),
            t("int"),
            t("DateTime"),
            t("string?"),
            t("bool?"),
            t("int?"),
            t("DateTime?")
        }),
        i(2, "MyVar")
    })),

    s("pubs", {
        t('public string '),
        i(1, "Id"),
        t(' { get; set; }'),
    }),

    s("pubi", {
        t('public int '),
        i(1, "Count"),
        t(' { get; set; }'),
    }),

    s("pubb", {
        t('public bool '),
        i(1, "Exists"),
        t(' { get; set; }'),
    }),

    s("public a", fmt(
    [[
    public async Task {}({}) {{
        {}
    }}
    ]], {
        i(1, "Run"), i(2, "object obj"), i(3, "return Task.CompletedTask;")
    })),

    s("xunit", fmt(
    [[
    namespace {};

    public class {} {{

      [Fact]
      public void Testing()
      {{
        Assert.True(true);
      }}
    }}
    ]], {
        i(1, "namspace"), i(2, "TestClass")
    }))
})




