FROM ghcr.io/qmk/qmk_cli@sha256:2dc05fc9f32efebd6b05c2b8676ee548358bc7e151e9dbf4dac6b6eed4513b07

ARG QMK_VERSION=0.22.14

RUN git clone --depth 1 --recurse-submodules --shallow-submodules \
      -b ${QMK_VERSION} https://github.com/qmk/qmk_firmware.git /qmk_firmware && \
    qmk setup --home /qmk_firmware --yes

RUN /usr/bin/python3 -m pip install --break-system-packages -r /qmk_firmware/requirements.txt

WORKDIR /keyball
