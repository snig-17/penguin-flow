// PenguinFlow Figma Plugin — Auto-generates design system + 11 mobile screens
// Run via Plugins > Development > Import plugin from manifest...

// ─── Color Palette ───────────────────────────────────────────────
const COLORS = {
  primary:      { r: 0.345, g: 0.800, b: 0.008 },   // #58CC02
  primaryDark:  { r: 0.278, g: 0.643, b: 0.004 },   // #47A401
  secondary:    { r: 0.110, g: 0.690, b: 0.965 },   // #1CB0F6
  secondaryDark:{ r: 0.082, g: 0.533, b: 0.757 },   // #1588C1
  accent:       { r: 1.000, g: 0.588, b: 0.000 },   // #FF9600
  accentDark:   { r: 0.804, g: 0.471, b: 0.000 },   // #CD7800
  background:   { r: 0.976, g: 0.980, b: 0.988 },   // #F9FAFC
  surface:      { r: 1.000, g: 1.000, b: 1.000 },   // #FFFFFF
  textPrimary:  { r: 0.133, g: 0.153, b: 0.200 },   // #222733
  textSecondary:{ r: 0.467, g: 0.498, b: 0.553 },   // #777F8D
  border:       { r: 0.878, g: 0.894, b: 0.918 },   // #E0E4EA
  error:        { r: 0.918, g: 0.200, b: 0.239 },   // #EA333D
  success:      { r: 0.345, g: 0.800, b: 0.008 },   // #58CC02
  white:        { r: 1, g: 1, b: 1 },
  black:        { r: 0, g: 0, b: 0 },
  dark:         { r: 0.133, g: 0.153, b: 0.200 },
  grey:         { r: 0.600, g: 0.620, b: 0.660 },
  lightGrey:    { r: 0.930, g: 0.940, b: 0.950 },
  overlay:      { r: 0, g: 0, b: 0 },
  gold:         { r: 1.000, g: 0.843, b: 0.000 },
  silver:       { r: 0.753, g: 0.753, b: 0.753 },
  bronze:       { r: 0.804, g: 0.498, b: 0.196 },
  ice:          { r: 0.800, g: 0.930, b: 1.000 },
  snow:         { r: 0.950, g: 0.970, b: 1.000 },
};

const SCREEN_W = 390;
const SCREEN_H = 844;
const FONT_FAMILY = "Inter"; // Fallback; Nunito may not be loaded in Figma by default

// ─── Helpers ─────────────────────────────────────────────────────
async function loadFonts() {
  const fonts = [
    { family: FONT_FAMILY, style: "Regular" },
    { family: FONT_FAMILY, style: "Bold" },
    { family: FONT_FAMILY, style: "Semi Bold" },
    { family: FONT_FAMILY, style: "Medium" },
    { family: FONT_FAMILY, style: "Light" },
  ];
  for (const f of fonts) {
    try { await figma.loadFontAsync(f); } catch (_) { /* skip unavailable */ }
  }
}

function rgb(color) { return { r: color.r, g: color.g, b: color.b }; }

function solid(color, opacity) {
  const paint = { type: "SOLID", color: rgb(color) };
  if (opacity !== undefined) paint.opacity = opacity;
  return [paint];
}

function createText(parent, x, y, w, text, size, color, style) {
  const t = figma.createText();
  t.x = x; t.y = y;
  if (w) t.resize(w, size + 8);
  t.characters = text;
  t.fontSize = size;
  t.fills = solid(color || COLORS.textPrimary);
  try { t.fontName = { family: FONT_FAMILY, style: style || "Regular" }; } catch (_) {}
  if (w) t.textAutoResize = "HEIGHT";
  parent.appendChild(t);
  return t;
}

function createRect(parent, x, y, w, h, color, radius) {
  const r = figma.createRectangle();
  r.x = x; r.y = y; r.resize(w, h);
  r.fills = solid(color);
  if (radius) r.cornerRadius = radius;
  parent.appendChild(r);
  return r;
}

function createEllipse(parent, x, y, w, h, color) {
  const e = figma.createEllipse();
  e.x = x; e.y = y; e.resize(w, h);
  e.fills = solid(color);
  parent.appendChild(e);
  return e;
}

function createFrame(parent, x, y, w, h, color, name) {
  const f = figma.createFrame();
  f.x = x; f.y = y; f.resize(w, h);
  f.fills = color ? solid(color) : [];
  f.name = name || "Frame";
  f.clipsContent = true;
  if (parent) parent.appendChild(f);
  return f;
}

function createButton(parent, x, y, w, h, label, bgColor, textColor, radius) {
  const bg = createRect(parent, x, y, w, h, bgColor, radius || 16);
  // Shadow for depth
  bg.effects = [{ type: "DROP_SHADOW", color: { r: 0, g: 0, b: 0, a: 0.12 }, offset: { x: 0, y: 3 }, radius: 6, visible: true, blendMode: "NORMAL", spread: 0 }];
  const t = createText(parent, x, y + (h - 18) / 2, w, label, 16, textColor || COLORS.white, "Bold");
  t.textAlignHorizontal = "CENTER";
  return bg;
}

function createInputField(parent, x, y, w, h, placeholder) {
  const bg = createRect(parent, x, y, w, h, COLORS.surface, 12);
  bg.strokes = solid(COLORS.border);
  bg.strokeWeight = 1.5;
  createText(parent, x + 16, y + (h - 14) / 2, w - 32, placeholder, 14, COLORS.textSecondary, "Regular");
  return bg;
}

function createStatusBar(parent, y) {
  createRect(parent, 0, y, SCREEN_W, 44, COLORS.surface);
  createText(parent, 24, y + 14, 50, "9:41", 15, COLORS.textPrimary, "Semi Bold");
  // Signal/battery icons (simplified rectangles)
  createRect(parent, SCREEN_W - 80, y + 17, 18, 11, COLORS.textPrimary, 2);
  createRect(parent, SCREEN_W - 56, y + 17, 16, 11, COLORS.textPrimary, 2);
  createRect(parent, SCREEN_W - 34, y + 15, 25, 13, COLORS.textPrimary, 3);
}

function createNavBar(parent, activeIndex) {
  const navY = SCREEN_H - 83;
  const navBg = createRect(parent, 0, navY, SCREEN_W, 83, COLORS.surface, 0);
  navBg.effects = [{ type: "DROP_SHADOW", color: { r: 0, g: 0, b: 0, a: 0.06 }, offset: { x: 0, y: -2 }, radius: 8, visible: true, blendMode: "NORMAL", spread: 0 }];

  const tabs = ["Home", "Timer", "Island", "Social", "Profile"];
  const icons = ["🏠", "⏱", "🏝", "👥", "👤"];
  const tabW = SCREEN_W / tabs.length;

  tabs.forEach((label, i) => {
    const tx = i * tabW;
    const isActive = i === activeIndex;
    const color = isActive ? COLORS.primary : COLORS.textSecondary;

    // Icon placeholder circle
    if (isActive) {
      createEllipse(parent, tx + (tabW - 32) / 2, navY + 8, 32, 32, COLORS.primary);
      createText(parent, tx, navY + 12, tabW, icons[i], 18, COLORS.white, "Regular").textAlignHorizontal = "CENTER";
    } else {
      createText(parent, tx, navY + 12, tabW, icons[i], 20, color, "Regular").textAlignHorizontal = "CENTER";
    }
    const t = createText(parent, tx, navY + 46, tabW, label, 10, color, isActive ? "Bold" : "Regular");
    t.textAlignHorizontal = "CENTER";
  });
}

function createCard(parent, x, y, w, h, radius) {
  const card = createRect(parent, x, y, w, h, COLORS.surface, radius || 16);
  card.effects = [{ type: "DROP_SHADOW", color: { r: 0, g: 0, b: 0, a: 0.06 }, offset: { x: 0, y: 2 }, radius: 8, visible: true, blendMode: "NORMAL", spread: 0 }];
  return card;
}

// ─── Screen: Design System ───────────────────────────────────────
function buildDesignSystem(page) {
  page.name = "🎨 Design System";

  const frame = createFrame(null, 0, 0, 1200, 2400, COLORS.background, "Design System");
  page.appendChild(frame);

  // Title
  createText(frame, 40, 40, 600, "PenguinFlow Design System", 36, COLORS.textPrimary, "Bold");
  createText(frame, 40, 90, 600, "Color palette, typography, and component library", 16, COLORS.textSecondary, "Regular");

  // ── Colors ──
  createText(frame, 40, 150, 400, "Color Palette", 24, COLORS.textPrimary, "Bold");

  const colorEntries = [
    ["Primary", "#58CC02", COLORS.primary],
    ["Primary Dark", "#47A401", COLORS.primaryDark],
    ["Secondary", "#1CB0F6", COLORS.secondary],
    ["Secondary Dark", "#1588C1", COLORS.secondaryDark],
    ["Accent", "#FF9600", COLORS.accent],
    ["Accent Dark", "#CD7800", COLORS.accentDark],
    ["Background", "#F9FAFC", COLORS.background],
    ["Surface", "#FFFFFF", COLORS.surface],
    ["Text Primary", "#222733", COLORS.textPrimary],
    ["Text Secondary", "#777F8D", COLORS.textSecondary],
    ["Border", "#E0E4EA", COLORS.border],
    ["Error", "#EA333D", COLORS.error],
  ];

  colorEntries.forEach(([name, hex, color], i) => {
    const col = i % 6;
    const row = Math.floor(i / 6);
    const cx = 40 + col * 185;
    const cy = 200 + row * 120;

    const swatch = createRect(frame, cx, cy, 160, 70, color, 12);
    if (name === "Surface" || name === "Background") {
      swatch.strokes = solid(COLORS.border);
      swatch.strokeWeight = 1;
    }
    createText(frame, cx, cy + 78, 160, name, 13, COLORS.textPrimary, "Semi Bold");
    createText(frame, cx, cy + 95, 160, hex, 12, COLORS.textSecondary, "Regular");
  });

  // ── Typography ──
  const typoY = 480;
  createText(frame, 40, typoY, 400, "Typography — Nunito (use Inter as Figma fallback)", 24, COLORS.textPrimary, "Bold");

  const typeEntries = [
    ["Heading 1", 32, "Bold"],
    ["Heading 2", 24, "Bold"],
    ["Heading 3", 20, "Semi Bold"],
    ["Body Large", 16, "Regular"],
    ["Body", 14, "Regular"],
    ["Caption", 12, "Regular"],
    ["Button", 16, "Bold"],
    ["Overline", 10, "Semi Bold"],
  ];

  let ty = typoY + 50;
  typeEntries.forEach(([name, size, style]) => {
    createText(frame, 40, ty, 300, name, 12, COLORS.textSecondary, "Regular");
    createText(frame, 200, ty, 500, `The quick brown fox — ${size}px ${style}`, size, COLORS.textPrimary, style);
    ty += size + 24;
  });

  // ── Buttons ──
  const btnY = ty + 30;
  createText(frame, 40, btnY, 400, "Buttons", 24, COLORS.textPrimary, "Bold");

  createButton(frame, 40,  btnY + 50, 200, 52, "Primary Button", COLORS.primary, COLORS.white);
  createButton(frame, 260, btnY + 50, 200, 52, "Secondary", COLORS.secondary, COLORS.white);
  createButton(frame, 480, btnY + 50, 200, 52, "Accent", COLORS.accent, COLORS.white);

  // Outlined buttons
  const obY = btnY + 120;
  const outlined1 = createRect(frame, 40, obY, 200, 52, COLORS.surface, 16);
  outlined1.strokes = solid(COLORS.primary);
  outlined1.strokeWeight = 2;
  createText(frame, 40, obY + 17, 200, "Outlined Primary", 14, COLORS.primary, "Bold").textAlignHorizontal = "CENTER";

  const outlined2 = createRect(frame, 260, obY, 200, 52, COLORS.surface, 16);
  outlined2.strokes = solid(COLORS.secondary);
  outlined2.strokeWeight = 2;
  createText(frame, 260, obY + 17, 200, "Outlined Secondary", 14, COLORS.secondary, "Bold").textAlignHorizontal = "CENTER";

  // ── Input Fields ──
  const inputY = obY + 80;
  createText(frame, 40, inputY, 400, "Input Fields", 24, COLORS.textPrimary, "Bold");
  createInputField(frame, 40, inputY + 50, 340, 52, "Email address");
  createInputField(frame, 40, inputY + 120, 340, 52, "Password");

  // ── Cards ──
  const cardY = inputY + 200;
  createText(frame, 40, cardY, 400, "Cards", 24, COLORS.textPrimary, "Bold");
  createCard(frame, 40, cardY + 50, 340, 120, 16);
  createText(frame, 60, cardY + 70, 300, "Card Title", 16, COLORS.textPrimary, "Bold");
  createText(frame, 60, cardY + 95, 300, "Card description text goes here with\nsupporting details.", 14, COLORS.textSecondary, "Regular");

  // ── Spacing / Radius ──
  const spY = cardY + 210;
  createText(frame, 40, spY, 400, "Spacing & Radius", 24, COLORS.textPrimary, "Bold");
  const spacings = [4, 8, 12, 16, 20, 24, 32];
  spacings.forEach((s, i) => {
    const sx = 40 + i * 80;
    createRect(frame, sx, spY + 50, s, 40, COLORS.primary, 4);
    createText(frame, sx, spY + 96, 60, `${s}px`, 11, COLORS.textSecondary, "Regular");
  });
}

// ─── Screen 1: Splash ────────────────────────────────────────────
function buildSplash(page, x) {
  const frame = createFrame(null, x, 0, SCREEN_W, SCREEN_H, COLORS.primary, "01 — Splash");
  page.appendChild(frame);

  // Gradient-like overlay
  createRect(frame, 0, 0, SCREEN_W, SCREEN_H / 2, COLORS.primaryDark, 0).opacity = 0.3;

  // Penguin mascot placeholder
  const penguinY = 260;
  createEllipse(frame, (SCREEN_W - 140) / 2, penguinY, 140, 140, COLORS.white);
  createEllipse(frame, (SCREEN_W - 100) / 2, penguinY + 20, 100, 100, COLORS.dark);
  // Eyes
  createEllipse(frame, SCREEN_W / 2 - 25, penguinY + 45, 18, 22, COLORS.white);
  createEllipse(frame, SCREEN_W / 2 + 7, penguinY + 45, 18, 22, COLORS.white);
  createEllipse(frame, SCREEN_W / 2 - 20, penguinY + 52, 10, 12, COLORS.dark);
  createEllipse(frame, SCREEN_W / 2 + 12, penguinY + 52, 10, 12, COLORS.dark);
  // Beak
  createEllipse(frame, SCREEN_W / 2 - 12, penguinY + 75, 24, 14, COLORS.accent);

  // App title
  const t = createText(frame, 0, 440, SCREEN_W, "PenguinFlow", 40, COLORS.white, "Bold");
  t.textAlignHorizontal = "CENTER";
  const sub = createText(frame, 0, 495, SCREEN_W, "Focus. Build. Grow.", 18, COLORS.white, "Regular");
  sub.textAlignHorizontal = "CENTER";
  sub.opacity = 0.85;

  // Loading indicator
  createRect(frame, (SCREEN_W - 120) / 2, 700, 120, 4, COLORS.white, 2).opacity = 0.4;
  createRect(frame, (SCREEN_W - 120) / 2, 700, 60, 4, COLORS.white, 2);
}

// ─── Screen 2: Login ─────────────────────────────────────────────
function buildLogin(page, x) {
  const frame = createFrame(null, x, 0, SCREEN_W, SCREEN_H, COLORS.background, "02 — Login");
  page.appendChild(frame);
  createStatusBar(frame, 0);

  // Logo small
  createEllipse(frame, (SCREEN_W - 64) / 2, 70, 64, 64, COLORS.primary);
  const logoT = createText(frame, 0, 80, SCREEN_W, "🐧", 36, COLORS.white, "Regular");
  logoT.textAlignHorizontal = "CENTER";

  const title = createText(frame, 0, 150, SCREEN_W, "Welcome Back!", 28, COLORS.textPrimary, "Bold");
  title.textAlignHorizontal = "CENTER";
  const sub = createText(frame, 0, 188, SCREEN_W, "Log in to continue your focus journey", 14, COLORS.textSecondary, "Regular");
  sub.textAlignHorizontal = "CENTER";

  // Form
  createText(frame, 32, 240, 200, "Email", 13, COLORS.textPrimary, "Semi Bold");
  createInputField(frame, 32, 262, SCREEN_W - 64, 52, "your@email.com");

  createText(frame, 32, 334, 200, "Password", 13, COLORS.textPrimary, "Semi Bold");
  createInputField(frame, 32, 356, SCREEN_W - 64, 52, "••••••••");

  const forgot = createText(frame, 0, 420, SCREEN_W - 32, "Forgot Password?", 13, COLORS.secondary, "Semi Bold");
  forgot.textAlignHorizontal = "RIGHT";

  createButton(frame, 32, 470, SCREEN_W - 64, 56, "Log In", COLORS.primary, COLORS.white);

  // Divider
  createRect(frame, 32, 554, (SCREEN_W - 100) / 2, 1, COLORS.border);
  const orT = createText(frame, 0, 544, SCREEN_W, "OR", 12, COLORS.textSecondary, "Semi Bold");
  orT.textAlignHorizontal = "CENTER";
  createRect(frame, SCREEN_W / 2 + 18, 554, (SCREEN_W - 100) / 2, 1, COLORS.border);

  // Social logins
  const gBtn = createRect(frame, 32, 586, SCREEN_W - 64, 52, COLORS.surface, 16);
  gBtn.strokes = solid(COLORS.border); gBtn.strokeWeight = 1.5;
  createText(frame, 32, 603, SCREEN_W - 64, "Continue with Google", 14, COLORS.textPrimary, "Semi Bold").textAlignHorizontal = "CENTER";

  const aBtn = createRect(frame, 32, 654, SCREEN_W - 64, 52, COLORS.dark, 16);
  createText(frame, 32, 671, SCREEN_W - 64, "Continue with Apple", 14, COLORS.white, "Semi Bold").textAlignHorizontal = "CENTER";

  // Sign up link
  const signupLink = createText(frame, 0, 740, SCREEN_W, "Don't have an account? Sign Up", 14, COLORS.textSecondary, "Regular");
  signupLink.textAlignHorizontal = "CENTER";
}

// ─── Screen 3: Sign Up ──────────────────────────────────────────
function buildSignup(page, x) {
  const frame = createFrame(null, x, 0, SCREEN_W, SCREEN_H, COLORS.background, "03 — Sign Up");
  page.appendChild(frame);
  createStatusBar(frame, 0);

  // Back arrow placeholder
  createText(frame, 20, 56, 40, "←", 24, COLORS.textPrimary, "Regular");

  const title = createText(frame, 0, 56, SCREEN_W, "Create Account", 28, COLORS.textPrimary, "Bold");
  title.textAlignHorizontal = "CENTER";
  const sub = createText(frame, 0, 94, SCREEN_W, "Start building your penguin island", 14, COLORS.textSecondary, "Regular");
  sub.textAlignHorizontal = "CENTER";

  // Avatar picker placeholder
  createEllipse(frame, (SCREEN_W - 80) / 2, 134, 80, 80, COLORS.lightGrey);
  const camText = createText(frame, 0, 157, SCREEN_W, "📷", 28, COLORS.textSecondary, "Regular");
  camText.textAlignHorizontal = "CENTER";

  // Form
  const formY = 240;
  createText(frame, 32, formY, 200, "Username", 13, COLORS.textPrimary, "Semi Bold");
  createInputField(frame, 32, formY + 22, SCREEN_W - 64, 50, "coolpenguin42");

  createText(frame, 32, formY + 90, 200, "Email", 13, COLORS.textPrimary, "Semi Bold");
  createInputField(frame, 32, formY + 112, SCREEN_W - 64, 50, "your@email.com");

  createText(frame, 32, formY + 180, 200, "Password", 13, COLORS.textPrimary, "Semi Bold");
  createInputField(frame, 32, formY + 202, SCREEN_W - 64, 50, "••••••••");

  createText(frame, 32, formY + 270, 200, "Confirm Password", 13, COLORS.textPrimary, "Semi Bold");
  createInputField(frame, 32, formY + 292, SCREEN_W - 64, 50, "••••••••");

  // Password strength bar
  createRect(frame, 32, formY + 352, (SCREEN_W - 64) * 0.66, 4, COLORS.accent, 2);
  createText(frame, 32, formY + 362, 200, "Medium strength", 11, COLORS.accent, "Regular");

  createButton(frame, 32, formY + 400, SCREEN_W - 64, 56, "Create Account", COLORS.primary, COLORS.white);

  const terms = createText(frame, 40, formY + 472, SCREEN_W - 80, "By signing up, you agree to our Terms of Service and Privacy Policy", 11, COLORS.textSecondary, "Regular");
  terms.textAlignHorizontal = "CENTER";

  const loginLink = createText(frame, 0, 756, SCREEN_W, "Already have an account? Log In", 14, COLORS.textSecondary, "Regular");
  loginLink.textAlignHorizontal = "CENTER";
}

// ─── Screen 4: Home ──────────────────────────────────────────────
function buildHome(page, x) {
  const frame = createFrame(null, x, 0, SCREEN_W, SCREEN_H, COLORS.background, "04 — Home");
  page.appendChild(frame);
  createStatusBar(frame, 0);

  // Header
  createText(frame, 24, 56, 250, "Good Morning! 🌅", 24, COLORS.textPrimary, "Bold");
  createText(frame, 24, 88, 250, "Ready to focus today?", 14, COLORS.textSecondary, "Regular");
  // Avatar
  createEllipse(frame, SCREEN_W - 64, 56, 40, 40, COLORS.primary);
  createText(frame, SCREEN_W - 64, 63, 40, "🐧", 22, COLORS.white, "Regular").textAlignHorizontal = "CENTER";

  // Daily streak card
  createCard(frame, 24, 120, SCREEN_W - 48, 90, 16);
  createText(frame, 44, 136, 100, "🔥 Daily Streak", 14, COLORS.textPrimary, "Semi Bold");
  createText(frame, 44, 160, 200, "7 days in a row!", 22, COLORS.accent, "Bold");
  createText(frame, SCREEN_W - 120, 150, 80, "7", 36, COLORS.accent, "Bold").textAlignHorizontal = "CENTER";

  // Quick start timer card
  createCard(frame, 24, 230, SCREEN_W - 48, 160, 20);
  createRect(frame, 24, 230, SCREEN_W - 48, 160, COLORS.primary, 20).opacity = 0.06;
  createText(frame, 44, 248, 200, "Start Focus Session", 18, COLORS.textPrimary, "Bold");
  createText(frame, 44, 274, 250, "Choose a duration and dive in", 13, COLORS.textSecondary, "Regular");
  // Duration chips
  const durations = ["15 min", "25 min", "45 min", "60 min"];
  durations.forEach((d, i) => {
    const chipX = 44 + i * 78;
    const isSelected = i === 1;
    createRect(frame, chipX, 304, 70, 34, isSelected ? COLORS.primary : COLORS.surface, 17);
    if (!isSelected) {
      const chip = createRect(frame, chipX, 304, 70, 34, COLORS.surface, 17);
      chip.strokes = solid(COLORS.border);
      chip.strokeWeight = 1;
    }
    createText(frame, chipX, 312, 70, d, 12, isSelected ? COLORS.white : COLORS.textPrimary, "Semi Bold").textAlignHorizontal = "CENTER";
  });
  createButton(frame, 44, 350, SCREEN_W - 88, 30, "▶  Start", COLORS.primary, COLORS.white, 15);

  // Today's stats
  createText(frame, 24, 410, 200, "Today's Progress", 18, COLORS.textPrimary, "Bold");

  // Stat cards row
  const stats = [
    { label: "Focus Time", value: "1h 45m", icon: "⏱", color: COLORS.secondary },
    { label: "Sessions", value: "3", icon: "✅", color: COLORS.primary },
    { label: "Coins", value: "120", icon: "🪙", color: COLORS.accent },
  ];
  stats.forEach((s, i) => {
    const sx = 24 + i * ((SCREEN_W - 48 - 16) / 3 + 8);
    const sw = (SCREEN_W - 48 - 16) / 3;
    createCard(frame, sx, 442, sw, 100, 14);
    createText(frame, sx, 455, sw, s.icon, 22, s.color, "Regular").textAlignHorizontal = "CENTER";
    createText(frame, sx, 484, sw, s.value, 18, COLORS.textPrimary, "Bold").textAlignHorizontal = "CENTER";
    createText(frame, sx, 508, sw, s.label, 10, COLORS.textSecondary, "Regular").textAlignHorizontal = "CENTER";
  });

  // Recent activity
  createText(frame, 24, 562, 200, "Recent Activity", 18, COLORS.textPrimary, "Bold");

  const activities = [
    { text: "Completed 45min deep work", time: "2h ago", icon: "🎯" },
    { text: "Earned 40 coins", time: "2h ago", icon: "🪙" },
    { text: "Built a new igloo!", time: "Yesterday", icon: "🏠" },
  ];
  activities.forEach((a, i) => {
    const ay = 596 + i * 60;
    createCard(frame, 24, ay, SCREEN_W - 48, 52, 12);
    createText(frame, 44, ay + 8, 30, a.icon, 18, COLORS.textPrimary, "Regular");
    createText(frame, 80, ay + 10, 220, a.text, 13, COLORS.textPrimary, "Semi Bold");
    createText(frame, 80, ay + 30, 220, a.time, 11, COLORS.textSecondary, "Regular");
  });

  createNavBar(frame, 0);
}

// ─── Screen 5: Timer ─────────────────────────────────────────────
function buildTimer(page, x) {
  const frame = createFrame(null, x, 0, SCREEN_W, SCREEN_H, COLORS.dark, "05 — Timer");
  page.appendChild(frame);

  // Minimal status bar on dark
  createText(frame, 24, 20, 50, "9:41", 15, COLORS.white, "Semi Bold");

  // Session label
  const label = createText(frame, 0, 80, SCREEN_W, "Deep Focus", 16, COLORS.white, "Semi Bold");
  label.textAlignHorizontal = "CENTER";
  label.opacity = 0.7;

  // Timer ring (outer)
  const ringSize = 260;
  const ringX = (SCREEN_W - ringSize) / 2;
  const ringY = 140;
  const outerRing = createEllipse(frame, ringX, ringY, ringSize, ringSize, COLORS.primary);
  outerRing.opacity = 0.15;
  // Inner dark circle
  createEllipse(frame, ringX + 12, ringY + 12, ringSize - 24, ringSize - 24, COLORS.dark);
  // Progress arc placeholder (colored segment)
  const progressRing = createEllipse(frame, ringX + 4, ringY + 4, ringSize - 8, ringSize - 8, COLORS.primary);
  progressRing.opacity = 0.25;

  // Time display
  const timeT = createText(frame, 0, ringY + 85, SCREEN_W, "18:42", 56, COLORS.white, "Bold");
  timeT.textAlignHorizontal = "CENTER";
  const remaining = createText(frame, 0, ringY + 150, SCREEN_W, "remaining", 14, COLORS.white, "Regular");
  remaining.textAlignHorizontal = "CENTER";
  remaining.opacity = 0.5;

  // Session info
  const infoY = 440;
  createCard(frame, 32, infoY, SCREEN_W - 64, 70, 16);
  createRect(frame, 32, infoY, SCREEN_W - 64, 70, COLORS.textPrimary, 16).opacity = 0.8;
  createText(frame, 56, infoY + 14, 100, "Session", 11, COLORS.textSecondary, "Regular");
  createText(frame, 56, infoY + 32, 100, "3 of 4", 16, COLORS.white, "Bold");
  createText(frame, 190, infoY + 14, 100, "Total Today", 11, COLORS.textSecondary, "Regular");
  createText(frame, 190, infoY + 32, 100, "1h 45m", 16, COLORS.white, "Bold");
  createText(frame, SCREEN_W - 100, infoY + 14, 70, "Coins", 11, COLORS.textSecondary, "Regular");
  createText(frame, SCREEN_W - 100, infoY + 32, 70, "+40 🪙", 16, COLORS.accent, "Bold");

  // Motivational quote
  const quoteT = createText(frame, 40, 545, SCREEN_W - 80, "\"The secret of getting ahead is getting started.\"", 14, COLORS.white, "Regular");
  quoteT.textAlignHorizontal = "CENTER";
  quoteT.opacity = 0.4;

  // Controls
  const ctrlY = 620;
  // Pause button (center)
  createEllipse(frame, (SCREEN_W - 72) / 2, ctrlY, 72, 72, COLORS.primary);
  const pauseT = createText(frame, 0, ctrlY + 22, SCREEN_W, "⏸", 28, COLORS.white, "Regular");
  pauseT.textAlignHorizontal = "CENTER";

  // Stop button (left)
  createEllipse(frame, SCREEN_W / 2 - 120, ctrlY + 14, 48, 48, COLORS.white);
  const stopColor = COLORS.error;
  createEllipse(frame, SCREEN_W / 2 - 120, ctrlY + 14, 48, 48, stopColor);
  const stopT = createText(frame, SCREEN_W / 2 - 120, ctrlY + 27, 48, "⏹", 20, COLORS.white, "Regular");
  stopT.textAlignHorizontal = "CENTER";

  // Skip button (right)
  createEllipse(frame, SCREEN_W / 2 + 72, ctrlY + 14, 48, 48, COLORS.white);
  createEllipse(frame, SCREEN_W / 2 + 72, ctrlY + 14, 48, 48, COLORS.textSecondary).opacity = 0.3;
  const skipT = createText(frame, SCREEN_W / 2 + 72, ctrlY + 27, 48, "⏭", 20, COLORS.white, "Regular");
  skipT.textAlignHorizontal = "CENTER";

  // Labels
  createText(frame, SCREEN_W / 2 - 132, ctrlY + 70, 72, "Stop", 11, COLORS.textSecondary, "Regular").textAlignHorizontal = "CENTER";
  createText(frame, 0, ctrlY + 80, SCREEN_W, "Pause", 12, COLORS.white, "Semi Bold").textAlignHorizontal = "CENTER";
  createText(frame, SCREEN_W / 2 + 60, ctrlY + 70, 72, "Skip", 11, COLORS.textSecondary, "Regular").textAlignHorizontal = "CENTER";

  // Phone down reminder
  const reminderT = createText(frame, 0, SCREEN_H - 60, SCREEN_W, "📱 Stay focused — put your phone down", 12, COLORS.white, "Regular");
  reminderT.textAlignHorizontal = "CENTER";
  reminderT.opacity = 0.3;
}

// ─── Screen 6: Session Complete ──────────────────────────────────
function buildSessionComplete(page, x) {
  const frame = createFrame(null, x, 0, SCREEN_W, SCREEN_H, COLORS.background, "06 — Session Complete");
  page.appendChild(frame);

  // Confetti-like colored dots at top
  const confettiColors = [COLORS.primary, COLORS.secondary, COLORS.accent, COLORS.gold];
  for (let i = 0; i < 20; i++) {
    const cx = Math.random() * SCREEN_W;
    const cy = 40 + Math.random() * 120;
    const size = 4 + Math.random() * 8;
    createEllipse(frame, cx, cy, size, size, confettiColors[i % 4]).opacity = 0.5;
  }

  // Trophy / celebration icon
  createEllipse(frame, (SCREEN_W - 100) / 2, 160, 100, 100, COLORS.primary);
  createEllipse(frame, (SCREEN_W - 100) / 2, 160, 100, 100, COLORS.primary).opacity = 0.15;
  const trophy = createText(frame, 0, 185, SCREEN_W, "🏆", 48, COLORS.white, "Regular");
  trophy.textAlignHorizontal = "CENTER";

  const title = createText(frame, 0, 285, SCREEN_W, "Session Complete!", 28, COLORS.textPrimary, "Bold");
  title.textAlignHorizontal = "CENTER";
  const sub = createText(frame, 0, 320, SCREEN_W, "Great focus! Keep the momentum going.", 14, COLORS.textSecondary, "Regular");
  sub.textAlignHorizontal = "CENTER";

  // Stats grid
  const statsY = 370;
  createCard(frame, 24, statsY, SCREEN_W - 48, 170, 20);

  const sessionStats = [
    { label: "Duration", value: "25:00", icon: "⏱" },
    { label: "Coins Earned", value: "+40", icon: "🪙" },
    { label: "Streak", value: "7 days", icon: "🔥" },
    { label: "XP Gained", value: "+120", icon: "⭐" },
  ];
  sessionStats.forEach((s, i) => {
    const col = i % 2;
    const row = Math.floor(i / 2);
    const sx = 48 + col * ((SCREEN_W - 96) / 2);
    const sy = statsY + 20 + row * 76;
    createText(frame, sx, sy, 30, s.icon, 24, COLORS.textPrimary, "Regular");
    createText(frame, sx + 38, sy + 2, 120, s.value, 20, COLORS.textPrimary, "Bold");
    createText(frame, sx + 38, sy + 26, 120, s.label, 12, COLORS.textSecondary, "Regular");
  });

  // Reward unlocked
  const rewardY = 570;
  createCard(frame, 24, rewardY, SCREEN_W - 48, 80, 16);
  createRect(frame, 24, rewardY, SCREEN_W - 48, 80, COLORS.accent, 16).opacity = 0.08;
  createText(frame, 48, rewardY + 16, 30, "🎁", 24, COLORS.accent, "Regular");
  createText(frame, 86, rewardY + 18, 200, "New Building Unlocked!", 15, COLORS.textPrimary, "Bold");
  createText(frame, 86, rewardY + 40, 200, "Ice Fishing Hut — check your shop", 12, COLORS.textSecondary, "Regular");

  // Action buttons
  createButton(frame, 32, 690, SCREEN_W - 64, 56, "Start Another Session", COLORS.primary, COLORS.white);

  const homeBtn = createRect(frame, 32, 762, SCREEN_W - 64, 48, COLORS.surface, 16);
  homeBtn.strokes = solid(COLORS.border); homeBtn.strokeWeight = 1.5;
  createText(frame, 32, 776, SCREEN_W - 64, "Back to Home", 14, COLORS.textPrimary, "Semi Bold").textAlignHorizontal = "CENTER";
}

// ─── Screen 7: Island ────────────────────────────────────────────
function buildIsland(page, x) {
  const frame = createFrame(null, x, 0, SCREEN_W, SCREEN_H, COLORS.ice, "07 — Island");
  page.appendChild(frame);
  createStatusBar(frame, 0);

  // Header bar
  createText(frame, 24, 56, 200, "My Island", 22, COLORS.textPrimary, "Bold");
  // Coins display
  createRect(frame, SCREEN_W - 110, 54, 86, 32, COLORS.surface, 16);
  createText(frame, SCREEN_W - 100, 60, 70, "🪙 2,450", 14, COLORS.textPrimary, "Bold");

  // Island view area (the main canvas)
  const islandY = 100;
  createRect(frame, 0, islandY, SCREEN_W, 480, COLORS.snow, 0);

  // Water at bottom of island view
  createRect(frame, 0, islandY + 380, SCREEN_W, 100, COLORS.secondary, 0).opacity = 0.15;

  // Snow ground
  createEllipse(frame, 20, islandY + 280, 350, 140, COLORS.white);

  // Buildings placed on island
  // Igloo
  createEllipse(frame, 80, islandY + 280, 80, 50, COLORS.white);
  createRect(frame, 80, islandY + 290, 80, 30, COLORS.white, 0);
  createRect(frame, 105, islandY + 295, 30, 25, COLORS.dark, 4);
  createText(frame, 80, islandY + 260, 80, "🏠", 28, COLORS.white, "Regular").textAlignHorizontal = "CENTER";

  // Fish shop
  createRect(frame, 200, islandY + 290, 70, 45, COLORS.secondary, 8);
  createRect(frame, 200, islandY + 275, 70, 20, COLORS.secondaryDark, 4);
  createText(frame, 200, islandY + 298, 70, "🐟", 22, COLORS.white, "Regular").textAlignHorizontal = "CENTER";

  // Tree
  createEllipse(frame, 290, islandY + 260, 50, 60, COLORS.primary);
  createRect(frame, 310, islandY + 310, 10, 30, COLORS.accentDark, 2);

  // Penguin characters on island
  createText(frame, 140, islandY + 310, 30, "🐧", 28, COLORS.textPrimary, "Regular");
  createText(frame, 260, islandY + 330, 30, "🐧", 22, COLORS.textPrimary, "Regular");

  // Bottom panel
  const panelY = 590;
  createCard(frame, 0, panelY, SCREEN_W, SCREEN_H - panelY, 24);

  createText(frame, 24, panelY + 20, 200, "Island Level 5", 18, COLORS.textPrimary, "Bold");
  // XP Progress bar
  createRect(frame, 24, panelY + 48, SCREEN_W - 48, 8, COLORS.lightGrey, 4);
  createRect(frame, 24, panelY + 48, (SCREEN_W - 48) * 0.65, 8, COLORS.primary, 4);
  createText(frame, 24, panelY + 62, 200, "650 / 1000 XP", 11, COLORS.textSecondary, "Regular");

  // Quick actions
  createButton(frame, 24, panelY + 90, (SCREEN_W - 56) / 2, 44, "🏪 Shop", COLORS.secondary, COLORS.white, 12);
  createButton(frame, (SCREEN_W + 8) / 2, panelY + 90, (SCREEN_W - 56) / 2, 44, "🔨 Build", COLORS.accent, COLORS.white, 12);

  // Buildings count
  createText(frame, 24, panelY + 148, 300, "Buildings: 8/20  •  Visitors: 3", 12, COLORS.textSecondary, "Regular");

  createNavBar(frame, 2);
}

// ─── Screen 8: Building Shop ─────────────────────────────────────
function buildShop(page, x) {
  const frame = createFrame(null, x, 0, SCREEN_W, SCREEN_H, COLORS.background, "08 — Building Shop");
  page.appendChild(frame);
  createStatusBar(frame, 0);

  // Header
  createText(frame, 20, 56, 40, "←", 24, COLORS.textPrimary, "Regular");
  createText(frame, 0, 58, SCREEN_W, "Building Shop", 22, COLORS.textPrimary, "Bold").textAlignHorizontal = "CENTER";
  // Coins
  createRect(frame, SCREEN_W - 110, 54, 86, 32, COLORS.surface, 16);
  createText(frame, SCREEN_W - 100, 60, 70, "🪙 2,450", 14, COLORS.textPrimary, "Bold");

  // Filter tabs
  const tabs = ["All", "Houses", "Shops", "Nature", "Special"];
  tabs.forEach((tab, i) => {
    const tx = 16 + i * 74;
    const isActive = i === 0;
    createRect(frame, tx, 104, 66, 32, isActive ? COLORS.primary : COLORS.surface, 16);
    if (!isActive) {
      const t = createRect(frame, tx, 104, 66, 32, COLORS.surface, 16);
      t.strokes = solid(COLORS.border); t.strokeWeight = 1;
    }
    createText(frame, tx, 111, 66, tab, 12, isActive ? COLORS.white : COLORS.textSecondary, "Semi Bold").textAlignHorizontal = "CENTER";
  });

  // Building grid (2 columns)
  const buildings = [
    { name: "Cozy Igloo", price: "200", icon: "🏠", owned: true },
    { name: "Fish Market", price: "350", icon: "🐟", owned: true },
    { name: "Ice Tower", price: "500", icon: "🗼", owned: false },
    { name: "Snow Café", price: "450", icon: "☕", owned: false },
    { name: "Lighthouse", price: "800", icon: "🗼", owned: false },
    { name: "Penguin Slide", price: "300", icon: "🎢", owned: false },
    { name: "Ice Rink", price: "600", icon: "⛸", owned: false },
    { name: "Library", price: "750", icon: "📚", owned: false },
  ];

  const gridY = 152;
  const cardW = (SCREEN_W - 48 - 12) / 2;

  buildings.forEach((b, i) => {
    const col = i % 2;
    const row = Math.floor(i / 2);
    const bx = 24 + col * (cardW + 12);
    const by = gridY + row * 180;

    createCard(frame, bx, by, cardW, 168, 16);

    // Icon area
    createRect(frame, bx + 12, by + 12, cardW - 24, 75, b.owned ? COLORS.primary : COLORS.lightGrey, 12);
    const iconBg = createRect(frame, bx + 12, by + 12, cardW - 24, 75, b.owned ? COLORS.primary : COLORS.lightGrey, 12);
    iconBg.opacity = b.owned ? 0.12 : 1;
    createText(frame, bx + 12, by + 28, cardW - 24, b.icon, 36, COLORS.textPrimary, "Regular").textAlignHorizontal = "CENTER";

    // Name + price
    createText(frame, bx + 12, by + 98, cardW - 24, b.name, 13, COLORS.textPrimary, "Semi Bold");

    if (b.owned) {
      createRect(frame, bx + 12, by + 126, cardW - 24, 30, COLORS.primary, 8).opacity = 0.1;
      createText(frame, bx + 12, by + 132, cardW - 24, "✓ Owned", 12, COLORS.primary, "Bold").textAlignHorizontal = "CENTER";
    } else {
      createButton(frame, bx + 12, by + 126, cardW - 24, 30, "🪙 " + b.price, COLORS.accent, COLORS.white, 8);
    }
  });
}

// ─── Screen 9: Social Feed ───────────────────────────────────────
function buildSocialFeed(page, x) {
  const frame = createFrame(null, x, 0, SCREEN_W, SCREEN_H, COLORS.background, "09 — Social Feed");
  page.appendChild(frame);
  createStatusBar(frame, 0);

  // Header
  createText(frame, 24, 56, 200, "Community", 22, COLORS.textPrimary, "Bold");
  // Add friend button
  createEllipse(frame, SCREEN_W - 56, 54, 36, 36, COLORS.secondary);
  createText(frame, SCREEN_W - 56, 60, 36, "+", 20, COLORS.white, "Bold").textAlignHorizontal = "CENTER";

  // Tabs: Feed / Friends
  createRect(frame, 24, 104, 100, 36, COLORS.primary, 18);
  createText(frame, 24, 112, 100, "Feed", 14, COLORS.white, "Bold").textAlignHorizontal = "CENTER";
  const friendsTab = createRect(frame, 132, 104, 100, 36, COLORS.surface, 18);
  friendsTab.strokes = solid(COLORS.border); friendsTab.strokeWeight = 1;
  createText(frame, 132, 112, 100, "Friends", 14, COLORS.textSecondary, "Semi Bold").textAlignHorizontal = "CENTER";

  // Feed posts
  const posts = [
    {
      user: "ArcticFox42", avatar: "🦊", time: "5m ago",
      text: "Just completed a 2-hour deep work session! 🔥",
      stats: "45min streak • 80 coins earned",
      likes: "24", comments: "5",
    },
    {
      user: "PolarBearPro", avatar: "🐻‍❄️", time: "1h ago",
      text: "My island hit Level 10! Check out my new lighthouse 🗼",
      stats: "Level 10 • 15 buildings",
      likes: "52", comments: "12",
    },
    {
      user: "SnowOwl", avatar: "🦉", time: "3h ago",
      text: "7-day streak! Who else is going strong this week?",
      stats: "7 day streak • 340 coins",
      likes: "38", comments: "8",
    },
  ];

  let postY = 160;
  posts.forEach((p) => {
    createCard(frame, 24, postY, SCREEN_W - 48, 155, 16);

    // User header
    createEllipse(frame, 40, postY + 16, 36, 36, COLORS.lightGrey);
    createText(frame, 44, postY + 22, 30, p.avatar, 18, COLORS.textPrimary, "Regular");
    createText(frame, 86, postY + 18, 180, p.user, 14, COLORS.textPrimary, "Bold");
    createText(frame, 86, postY + 36, 180, p.time, 11, COLORS.textSecondary, "Regular");

    // Post content
    createText(frame, 40, postY + 64, SCREEN_W - 96, p.text, 14, COLORS.textPrimary, "Regular");

    // Stats tag
    createRect(frame, 40, postY + 94, SCREEN_W - 96, 24, COLORS.primary, 6).opacity = 0.08;
    createText(frame, 50, postY + 98, SCREEN_W - 116, p.stats, 11, COLORS.primary, "Semi Bold");

    // Like / Comment
    createText(frame, 40, postY + 128, 100, "❤️ " + p.likes, 12, COLORS.textSecondary, "Regular");
    createText(frame, 110, postY + 128, 100, "💬 " + p.comments, 12, COLORS.textSecondary, "Regular");

    postY += 170;
  });

  createNavBar(frame, 3);
}

// ─── Screen 10: Leaderboard ──────────────────────────────────────
function buildLeaderboard(page, x) {
  const frame = createFrame(null, x, 0, SCREEN_W, SCREEN_H, COLORS.background, "10 — Leaderboard");
  page.appendChild(frame);
  createStatusBar(frame, 0);

  createText(frame, 0, 56, SCREEN_W, "Leaderboard", 22, COLORS.textPrimary, "Bold").textAlignHorizontal = "CENTER";

  // Period tabs
  const periods = ["Weekly", "Monthly", "All Time"];
  periods.forEach((p, i) => {
    const pw = (SCREEN_W - 48 - 16) / 3;
    const px = 24 + i * (pw + 8);
    const isActive = i === 0;
    createRect(frame, px, 96, pw, 34, isActive ? COLORS.secondary : COLORS.surface, 17);
    if (!isActive) {
      const tab = createRect(frame, px, 96, pw, 34, COLORS.surface, 17);
      tab.strokes = solid(COLORS.border); tab.strokeWeight = 1;
    }
    createText(frame, px, 104, pw, p, 13, isActive ? COLORS.white : COLORS.textSecondary, "Semi Bold").textAlignHorizontal = "CENTER";
  });

  // Podium — top 3
  const podiumY = 160;

  // 2nd place (left)
  createRect(frame, 24, podiumY + 40, 100, 100, COLORS.surface, 16);
  createEllipse(frame, 49, podiumY, 50, 50, COLORS.lightGrey);
  createText(frame, 49, podiumY + 10, 50, "🐻‍❄️", 24, COLORS.white, "Regular").textAlignHorizontal = "CENTER";
  createEllipse(frame, 64, podiumY + 40, 20, 20, COLORS.silver);
  createText(frame, 64, podiumY + 43, 20, "2", 12, COLORS.white, "Bold").textAlignHorizontal = "CENTER";
  createText(frame, 24, podiumY + 68, 100, "PolarBear", 12, COLORS.textPrimary, "Semi Bold").textAlignHorizontal = "CENTER";
  createText(frame, 24, podiumY + 86, 100, "2,840 XP", 11, COLORS.textSecondary, "Regular").textAlignHorizontal = "CENTER";

  // 1st place (center, elevated)
  createRect(frame, (SCREEN_W - 120) / 2, podiumY + 10, 120, 130, COLORS.surface, 16);
  createRect(frame, (SCREEN_W - 120) / 2, podiumY + 10, 120, 130, COLORS.accent, 16).opacity = 0.06;
  createEllipse(frame, (SCREEN_W - 60) / 2, podiumY - 30, 60, 60, COLORS.lightGrey);
  createText(frame, (SCREEN_W - 60) / 2, podiumY - 18, 60, "🦊", 28, COLORS.white, "Regular").textAlignHorizontal = "CENTER";
  createEllipse(frame, (SCREEN_W - 24) / 2, podiumY + 20, 24, 24, COLORS.gold);
  createText(frame, (SCREEN_W - 24) / 2, podiumY + 24, 24, "1", 13, COLORS.white, "Bold").textAlignHorizontal = "CENTER";
  createText(frame, 0, podiumY + 52, SCREEN_W, "ArcticFox42", 13, COLORS.textPrimary, "Bold").textAlignHorizontal = "CENTER";
  createText(frame, 0, podiumY + 72, SCREEN_W, "3,250 XP", 12, COLORS.accent, "Bold").textAlignHorizontal = "CENTER";
  createText(frame, 0, podiumY + 92, SCREEN_W, "👑 Champion", 11, COLORS.accent, "Semi Bold").textAlignHorizontal = "CENTER";

  // 3rd place (right)
  createRect(frame, SCREEN_W - 124, podiumY + 40, 100, 100, COLORS.surface, 16);
  createEllipse(frame, SCREEN_W - 99, podiumY, 50, 50, COLORS.lightGrey);
  createText(frame, SCREEN_W - 99, podiumY + 10, 50, "🦉", 24, COLORS.white, "Regular").textAlignHorizontal = "CENTER";
  createEllipse(frame, SCREEN_W - 84, podiumY + 40, 20, 20, COLORS.bronze);
  createText(frame, SCREEN_W - 84, podiumY + 43, 20, "3", 12, COLORS.white, "Bold").textAlignHorizontal = "CENTER";
  createText(frame, SCREEN_W - 124, podiumY + 68, 100, "SnowOwl", 12, COLORS.textPrimary, "Semi Bold").textAlignHorizontal = "CENTER";
  createText(frame, SCREEN_W - 124, podiumY + 86, 100, "2,610 XP", 11, COLORS.textSecondary, "Regular").textAlignHorizontal = "CENTER";

  // List (4th onwards)
  const listY = 320;
  const leaderboardData = [
    { rank: 4, name: "IcePenguin", xp: "2,100", avatar: "🐧" },
    { rank: 5, name: "FrostWolf", xp: "1,980", avatar: "🐺" },
    { rank: 6, name: "SnowLeopard", xp: "1,870", avatar: "🐆" },
    { rank: 7, name: "AuroraSeal", xp: "1,650", avatar: "🦭" },
    { rank: 8, name: "GlacierFox", xp: "1,520", avatar: "🦊" },
  ];

  leaderboardData.forEach((entry, i) => {
    const ey = listY + i * 62;
    createCard(frame, 24, ey, SCREEN_W - 48, 54, 14);

    createText(frame, 40, ey + 17, 24, `${entry.rank}`, 16, COLORS.textSecondary, "Bold");
    createEllipse(frame, 72, ey + 10, 34, 34, COLORS.lightGrey);
    createText(frame, 72, ey + 14, 34, entry.avatar, 18, COLORS.textPrimary, "Regular").textAlignHorizontal = "CENTER";
    createText(frame, 116, ey + 12, 150, entry.name, 14, COLORS.textPrimary, "Semi Bold");
    createText(frame, 116, ey + 30, 150, entry.xp + " XP", 12, COLORS.textSecondary, "Regular");

    // Trend arrow
    createText(frame, SCREEN_W - 70, ey + 17, 30, "↑", 16, COLORS.primary, "Bold");
  });

  // Your position
  const yourY = listY + 5 * 62 + 10;
  createCard(frame, 24, yourY, SCREEN_W - 48, 54, 14);
  createRect(frame, 24, yourY, SCREEN_W - 48, 54, COLORS.primary, 14).opacity = 0.08;
  createText(frame, 40, yourY + 17, 24, "12", 16, COLORS.primary, "Bold");
  createEllipse(frame, 72, yourY + 10, 34, 34, COLORS.primary);
  createText(frame, 72, yourY + 14, 34, "🐧", 18, COLORS.white, "Regular").textAlignHorizontal = "CENTER";
  createText(frame, 116, yourY + 12, 150, "You", 14, COLORS.primary, "Bold");
  createText(frame, 116, yourY + 30, 150, "980 XP", 12, COLORS.textSecondary, "Regular");

  createNavBar(frame, 3);
}

// ─── Screen 11: Profile ─────────────────────────────────────────
function buildProfile(page, x) {
  const frame = createFrame(null, x, 0, SCREEN_W, SCREEN_H, COLORS.background, "11 — Profile");
  page.appendChild(frame);
  createStatusBar(frame, 0);

  // Header gradient area
  createRect(frame, 0, 44, SCREEN_W, 140, COLORS.primary, 0);

  // Settings icon
  createText(frame, SCREEN_W - 48, 56, 30, "⚙", 22, COLORS.white, "Regular");

  // Avatar
  const avatarY = 120;
  createEllipse(frame, (SCREEN_W - 88) / 2, avatarY, 88, 88, COLORS.surface);
  createEllipse(frame, (SCREEN_W - 80) / 2, avatarY + 4, 80, 80, COLORS.primary);
  createText(frame, 0, avatarY + 22, SCREEN_W, "🐧", 40, COLORS.white, "Regular").textAlignHorizontal = "CENTER";

  // Edit avatar badge
  createEllipse(frame, SCREEN_W / 2 + 28, avatarY + 68, 24, 24, COLORS.secondary);
  createText(frame, SCREEN_W / 2 + 28, avatarY + 72, 24, "✏️", 12, COLORS.white, "Regular").textAlignHorizontal = "CENTER";

  // Username
  createText(frame, 0, 222, SCREEN_W, "CoolPenguin42", 22, COLORS.textPrimary, "Bold").textAlignHorizontal = "CENTER";
  createText(frame, 0, 250, SCREEN_W, "Joined March 2026 • Level 5", 13, COLORS.textSecondary, "Regular").textAlignHorizontal = "CENTER";

  // Stats row
  const statRowY = 285;
  createCard(frame, 24, statRowY, SCREEN_W - 48, 80, 16);

  const profileStats = [
    { value: "42h", label: "Focus Time" },
    { value: "7", label: "Streak" },
    { value: "2,450", label: "Coins" },
    { value: "980", label: "XP" },
  ];
  profileStats.forEach((s, i) => {
    const sw = (SCREEN_W - 48) / 4;
    const sx = 24 + i * sw;
    createText(frame, sx, statRowY + 18, sw, s.value, 20, COLORS.primary, "Bold").textAlignHorizontal = "CENTER";
    createText(frame, sx, statRowY + 44, sw, s.label, 11, COLORS.textSecondary, "Regular").textAlignHorizontal = "CENTER";
  });

  // Achievements section
  const achY = 390;
  createText(frame, 24, achY, 200, "Achievements", 18, COLORS.textPrimary, "Bold");
  createText(frame, SCREEN_W - 80, achY + 4, 60, "See all", 13, COLORS.secondary, "Semi Bold");

  const achievements = [
    { icon: "🔥", name: "7-Day Streak", desc: "Focus 7 days in a row" },
    { icon: "🏗", name: "Builder", desc: "Place 5 buildings" },
    { icon: "⏱", name: "Marathon", desc: "60min session completed" },
    { icon: "🌟", name: "Rising Star", desc: "Reach Level 5" },
  ];
  achievements.forEach((a, i) => {
    const ay = achY + 36 + i * 56;
    createCard(frame, 24, ay, SCREEN_W - 48, 50, 12);
    createEllipse(frame, 36, ay + 8, 34, 34, COLORS.primary);
    createEllipse(frame, 36, ay + 8, 34, 34, COLORS.primary).opacity = 0.12;
    createText(frame, 36, ay + 13, 34, a.icon, 18, COLORS.textPrimary, "Regular").textAlignHorizontal = "CENTER";
    createText(frame, 80, ay + 10, 200, a.name, 13, COLORS.textPrimary, "Semi Bold");
    createText(frame, 80, ay + 28, 200, a.desc, 11, COLORS.textSecondary, "Regular");
    // Completed check
    createText(frame, SCREEN_W - 60, ay + 15, 24, "✅", 16, COLORS.primary, "Regular");
  });

  // Settings list
  const setY = achY + 36 + 4 * 56 + 16;
  const settings = ["Edit Profile", "Notifications", "Privacy", "Help & Support"];
  settings.forEach((s, i) => {
    const sy = setY + i * 48;
    createCard(frame, 24, sy, SCREEN_W - 48, 42, 10);
    createText(frame, 44, sy + 12, 200, s, 14, COLORS.textPrimary, "Regular");
    createText(frame, SCREEN_W - 56, sy + 12, 20, "→", 14, COLORS.textSecondary, "Regular");
  });

  createNavBar(frame, 4);
}

// ─── Main ────────────────────────────────────────────────────────
async function main() {
  await loadFonts();

  // Create design system page
  const dsPage = figma.createPage();
  buildDesignSystem(dsPage);

  // Create screens page
  const screensPage = figma.createPage();
  screensPage.name = "📱 Mobile Screens";

  const gap = 60;
  let x = 0;

  buildSplash(screensPage, x);          x += SCREEN_W + gap;
  buildLogin(screensPage, x);           x += SCREEN_W + gap;
  buildSignup(screensPage, x);          x += SCREEN_W + gap;
  buildHome(screensPage, x);            x += SCREEN_W + gap;
  buildTimer(screensPage, x);           x += SCREEN_W + gap;
  buildSessionComplete(screensPage, x); x += SCREEN_W + gap;
  buildIsland(screensPage, x);          x += SCREEN_W + gap;
  buildShop(screensPage, x);            x += SCREEN_W + gap;
  buildSocialFeed(screensPage, x);      x += SCREEN_W + gap;
  buildLeaderboard(screensPage, x);     x += SCREEN_W + gap;
  buildProfile(screensPage, x);

  // Set the screens page as current
  figma.currentPage = screensPage;

  // Zoom to fit
  figma.viewport.scrollAndZoomIntoView(screensPage.children);

  figma.notify("✅ PenguinFlow — 11 screens + design system generated!");
  figma.closePlugin();
}

main();
