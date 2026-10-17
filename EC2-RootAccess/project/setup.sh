#!/usr/bin/env bash
# ------------------------------------------------------------------
#  Auto-Root Login Setup
#  Makes SSH logins as a normal user switch to root automatically
#  (with root's password prompt) by adding `exec su -` to ~/.bashrc.
#
#  Usage:
#    ./setup.sh              install
#    ./setup.sh status       show whether it is active
#    ./setup.sh uninstall    remove it
#    ./setup.sh --dry-run    show what would happen, change nothing
#
#  Tested on: Ubuntu (AWS EC2), connected through MobaXterm.
#  For lab use only. Do not use on production servers.
# ------------------------------------------------------------------
set -uo pipefail

# ---------- UI helpers ----------
if [[ -t 1 ]]; then
  R=$'\e[31m'; G=$'\e[32m'; Y=$'\e[33m'; B=$'\e[34m'; C=$'\e[36m'
  BOLD=$'\e[1m'; DIM=$'\e[2m'; RST=$'\e[0m'
else
  R=""; G=""; Y=""; B=""; C=""; BOLD=""; DIM=""; RST=""
fi

LINE='[[ $- == *i* && $EUID -ne 0 ]] && exec su -'
MARK='# auto-root-login'
DRY=0
ACTION="install"

banner() {
  echo
  echo "${C}+--------------------------------------------------+${RST}"
  echo "${C}|${RST}  ${BOLD}AUTO-ROOT LOGIN${RST}  ${DIM}Ubuntu + MobaXterm setup${RST}       ${C}|${RST}"
  echo "${C}+--------------------------------------------------+${RST}"
  echo
}
step()  { echo "${B}[$1/$TOTAL]${RST} ${BOLD}$2${RST}"; }
ok()    { echo "      ${G}[ OK ]${RST} $1"; }
warn()  { echo "      ${Y}[WARN]${RST} $1"; }
fail()  { echo "      ${R}[FAIL]${RST} $1"; exit 1; }
info()  { echo "      ${DIM}$1${RST}"; }
run()   { if (( DRY )); then info "(dry-run) $*"; else "$@"; fi; }

# ---------- args ----------
for a in "$@"; do
  case "$a" in
    install|status|uninstall) ACTION="$a" ;;
    --dry-run) DRY=1 ;;
    -h|--help) sed -n '2,15p' "$0"; exit 0 ;;
    *) echo "Unknown option: $a (try --help)"; exit 1 ;;
  esac
done

# ---------- target user ----------
TARGET_USER="${SUDO_USER:-$(id -un)}"
[[ "$TARGET_USER" == "root" ]] && TARGET_USER="ubuntu"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
[[ -z "$TARGET_HOME" || ! -d "$TARGET_HOME" ]] && { echo "${R}User '$TARGET_USER' not found.${RST}"; exit 1; }
BASHRC="$TARGET_HOME/.bashrc"

SUDO=""
[[ $EUID -ne 0 ]] && SUDO="sudo"

is_installed() { grep -qxF "$LINE" "$BASHRC" 2>/dev/null; }

banner
echo "  Target user : ${BOLD}$TARGET_USER${RST}"
echo "  File        : ${BOLD}$BASHRC${RST}"
(( DRY )) && echo "  Mode        : ${Y}DRY RUN (nothing will change)${RST}"
echo

# ---------- status ----------
if [[ "$ACTION" == "status" ]]; then
  if is_installed; then
    echo "  Status: ${G}ACTIVE${RST}  (logins as $TARGET_USER switch to root)"
  else
    echo "  Status: ${Y}NOT INSTALLED${RST}"
  fi
  echo
  exit 0
fi

# ---------- uninstall ----------
if [[ "$ACTION" == "uninstall" ]]; then
  TOTAL=2
  step 1 "Checking current state"
  is_installed && ok "Auto-root line found" || { warn "Line not found. Nothing to remove."; exit 0; }

  step 2 "Removing the line"
  if (( DRY )); then
    info "(dry-run) would remove the auto-root line and its marker"
  else
    $SUDO cp -p "$BASHRC" "$BASHRC.bak.$(date +%s)"
    $SUDO sed -i "\|^$(printf '%s' "$LINE" | sed 's/[][\.*^$/]/\\&/g')\$|d;\|^$MARK\$|d" "$BASHRC"
  fi
  ok "Removed. New logins will stay as $TARGET_USER."
  echo
  exit 0
fi

# ---------- install ----------
TOTAL=5

step 1 "Pre-flight checks"
command -v su >/dev/null  || fail "'su' not found."
command -v passwd >/dev/null || fail "'passwd' not found."
if [[ -n "$SUDO" ]]; then
  sudo -v 2>/dev/null || fail "sudo access is required."
fi
ok "Running checks passed"
echo
echo "      ${Y}Keep another terminal tab open while you test.${RST}"
echo "      ${DIM}A wrong root password closes the new session.${RST}"
echo

if is_installed; then
  warn "Already installed. Skipping to verification."
  SKIP=1
else
  SKIP=0
fi

step 2 "Set the root password"
if (( SKIP )); then
  info "Skipped (already installed)"
else
  read -r -p "      Set or change root's password now? [Y/n] " ans
  if [[ "${ans:-Y}" =~ ^[Yy]$ ]]; then
    if (( DRY )); then info "(dry-run) would run: $SUDO passwd root"
    else $SUDO passwd root || fail "Could not set the root password."
    fi
    ok "Root password set"
  else
    warn "Skipped. Make sure root already has a password, or login will fail."
  fi
fi

step 3 "Back up .bashrc"
if (( SKIP )); then
  info "Skipped (already installed)"
else
  BK="$BASHRC.bak.$(date +%s)"
  run $SUDO cp -p "$BASHRC" "$BK"
  ok "Backup: $BK"
fi

step 4 "Add the auto-switch line"
if (( SKIP )); then
  info "Skipped (already installed)"
elif (( DRY )); then
  info "(dry-run) would append the line to $BASHRC"
else
  { echo "$MARK"; echo "$LINE"; } | $SUDO tee -a "$BASHRC" >/dev/null
  ok "Line added"
fi

step 5 "Verify"
if (( DRY )); then
  info "(dry-run) skipped"
elif is_installed; then
  ok "Line present in $BASHRC"
  echo
  echo "      ${DIM}$(tail -n 2 "$BASHRC" | sed 's/^/      /')${RST}"
else
  fail "Line not found after install."
fi

echo
echo "${G}${BOLD}Done.${RST}"
echo "  Next: open a ${BOLD}new${RST} SSH tab as ${BOLD}$TARGET_USER${RST}."
echo "  You should get a Password: prompt, then a ${BOLD}root@...#${RST} shell."
echo "  Undo anytime with: ${BOLD}./setup.sh uninstall${RST}"
echo
