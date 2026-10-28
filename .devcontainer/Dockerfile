FROM node:20

ENV ELAN_HOME=/usr/local/elan \
  PATH=/usr/local/elan/bin:$PATH

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

COPY ./lean-toolchain /lean-toolchain

# Install the Lean toolchain pinned by `lean-toolchain`.
RUN curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf \
    | sh -s -- -y --no-modify-path --default-toolchain "$(cat /lean-toolchain)"; \
  chmod -R a+w $ELAN_HOME; \
  lean --version; \
  lake --version

USER node
WORKDIR /home/node

# Clone the game engine and install its npm dependencies here, so they are cached in the image
# rather than redone per container. By default this is the upstream tag matching our Lean
# version; set LEAN4GAME_REPO / LEAN4GAME_REF (see docker-compose.yml) to build against a fork.
ARG LEAN4GAME_REPO=https://github.com/leanprover-community/lean4game.git
ARG LEAN4GAME_REF=
RUN git clone --depth 1 --branch "${LEAN4GAME_REF:-$(grep -oE '[^:]+$' /lean-toolchain)}" \
    "$LEAN4GAME_REPO" lean4game \
  && cd lean4game && npm install

# Engine fixes we carry on top of upstream (exported from our engine fork with
# `git format-patch`). Patches the engine already contains, e.g. when building against
# our fork, are skipped.
COPY --chown=node .devcontainer/lean4game-patches /home/node/lean4game-patches
RUN cd lean4game && for p in ../lean4game-patches/*.patch; do \
    [ -e "$p" ] || continue; \
    if git apply --reverse --check "$p" 2>/dev/null; then echo "already applied: $p"; \
    else git apply "$p" && echo "applied: $p"; fi; \
  done

# Mount point for the `.lake` named volume (see docker-compose.yml). Creating it here
# makes the volume owned by `node` instead of `root`.
RUN mkdir -p /home/node/game/.lake
# Keep Mathlib's downloaded cache in that volume too, so restarts don't download it again.
ENV MATHLIB_CACHE_DIR=/home/node/game/.lake/mathlib-cache

WORKDIR /home/node/game
