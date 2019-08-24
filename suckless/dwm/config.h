/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx = 3;        /* border pixel of windows */
static const unsigned int gappx    = 16;        /* gap pixel between windows */
static const unsigned int snap     = 8;       /* snap pixel */
static const int showbar           = 1;        /* 0 means no bar */
static const int topbar            = 1;        /* 0 means bottom bar */
static const int xbar              = 128;        /* horizontal offset for statusbar */
static const int ybar              = 16;        /* vertical offset for statusbar */
static const int horizpadbar       = 0;        /* horizontal padding for statusbar */
static const int vertpadbar        = 16;        /* vertical padding for statusbar */
static const char *fonts[]         = { " Misc Tamsyn:style=Regular:pixelsize=16" };
static const char dmenufont[]      = " Misc Tamsyn:style=Regular:pixelsize=16";
static const char col_bg[]         = "#282828";
static const char col_fg[]         = "#ebdbb2";
static const char col_highlight[]  = "#d79921";
static const char col_gray1[]      = "#1d2021";
static const char col_gray2[]      = "#3c3836";
static const char col_green[]      = "#689d6a";
static const char col_red[]        = "#cc241d";
static const char *colors[][3]     = {
    /*               fg              bg              border   */
    [SchemeNorm] = { col_fg        , col_bg        , col_bg        } , /* 1: normal */
    [SchemeSel]  = { col_highlight , col_bg        , col_highlight } , /* 2: selected */
    [SchemeHl]   = { col_bg        , col_highlight , col_highlight } , /* 3: highlight */
    [SchemeLt]   = { col_fg        , col_gray2     , col_bg        } , /* 4: light bg */
    [SchemeSeLt] = { col_highlight , col_gray2     , col_bg        } , /* 5: selected light bg */
    [SchemeGr]   = { col_fg        , col_green     , col_bg        } , /* 6: green */
    [SchemeGrHl] = { col_highlight , col_green     , col_bg        } , /* 7: green highlight */
    [SchemeRd]   = { col_fg        , col_red       , col_bg        } , /* 8: red */
    [SchemeRdHl] = { col_highlight , col_red       , col_bg        } , /* 9: red highlight */
};

/* tagging */
static const char *tags[] = { "one", "two", "three", "four", "five", "six" };

static const Rule rules[] = {
    /* xprop(1):
     *	WM_CLASS(STRING) = instance, class
     *	WM_NAME(STRING) = title
     */
    /* class      instance    title       tags mask     isfloating   monitor */
    { "Gimp",     NULL,       NULL,       0,            1,           -1 },
    { "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
    /* symbol     arrange function */
    { "[T]",      tile },    /* first entry is default */
    { "[F]",      NULL },    /* no layout function means floating behavior */
    { "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont,
                                "-h", "32", "-x", "128", "-y", "16", "-w", "1664", NULL };
static const char *termcmd[]  = { "urxvt", NULL };
static const char *lock[]     = { "lock.sh", NULL };

static Key keys[] = {
    /* modifier                     key        function        argument */
    { MODKEY,                       XK_d,      spawn,          {.v = dmenucmd } },
    { MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
    { MODKEY,                       XK_F9,     spawn,          {.v = lock } },
    { MODKEY,                       XK_b,      togglebar,      {0} },
    { MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
    { MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
    { MODKEY|ShiftMask,             XK_h,      incnmaster,     {.i = +1 } },
    { MODKEY|ShiftMask,             XK_l,      incnmaster,     {.i = -1 } },
    { MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
    { MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_period, setcfact,       {.f = +0.25} },
	{ MODKEY,                       XK_comma,  setcfact,       {.f = -0.25} },
	{ MODKEY|ShiftMask,             XK_o,      setcfact,       {.f =  0.00} },
    { MODKEY,                       XK_f,      zoom,           {0} },
    { MODKEY,                       XK_grave,  view,           {0} },
    { MODKEY|ShiftMask,             XK_q,      killclient,     {0} },
    { MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
    { MODKEY,                       XK_s,      setlayout,      {.v = &layouts[1]} },
    { MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
    { MODKEY,                       XK_space,  setlayout,      {0} },
    { MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
    { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
    { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
    { MODKEY,                       XK_z,      focusmon,       {.i = -1 } },
    { MODKEY,                       XK_x,      focusmon,       {.i = +1 } },
    { MODKEY,                       XK_Tab,    focusmon,       {.i = +1 } },
    { MODKEY|ShiftMask,             XK_z,      tagmon,         {.i = -1 } },
    { MODKEY|ShiftMask,             XK_x,      tagmon,         {.i = +1 } },
    TAGKEYS(                        XK_1,                      0)
    TAGKEYS(                        XK_2,                      1)
    TAGKEYS(                        XK_3,                      2)
    TAGKEYS(                        XK_4,                      3)
    TAGKEYS(                        XK_5,                      4)
    TAGKEYS(                        XK_6,                      5)
    TAGKEYS(                        XK_7,                      6)
    { MODKEY|ShiftMask,             XK_Escape, quit,           {0} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
    /* click                event mask      button          function        argument */
    { ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
    { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
    { ClkWinTitle,          0,              Button2,        zoom,           {0} },
    { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
    { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
    { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
    { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
    { ClkTagBar,            0,              Button1,        view,           {0} },
    { ClkTagBar,            0,              Button3,        toggleview,     {0} },
    { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
    { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

