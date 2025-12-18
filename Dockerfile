# Start from your current final image
FROM dockerdex.umcn.nl:5005/diag/final-image:latest 

USER root

# 1. Add the new requirements
COPY requirements-panther.txt /root/python-packages/requirements-panther.txt

# 2. Sync requirements
# We use pip-sync if you have a compiled .txt, or simply pip install.
# Since we are adding to an existing environment, 'pip install' is safer 
# to avoid uninstalling the base pathology tools.
RUN pip3 install --no-cache-dir -r /root/python-packages/requirements-panther.txt

# 3. Fix ASAP for Python 3.11 (Confirmation)
# Your FINAL DOCKER already does this, but we'll ensure it's robust:
RUN SITE_PACKAGES=`python3 -c "import sysconfig; print(sysconfig.get_paths()['purelib'])"` && \
    printf "/opt/ASAP/bin/\n" > "${SITE_PACKAGES}/asap.pth"

# 4. Final Smoke Test
# This ensures ASAP and Torch (CUDA) are both working in the same env
RUN python3 -c "import asap; import torch; print(f'ASAP Loaded. CUDA Available: {torch.cuda.is_available()}')"

WORKDIR /home/user
USER user
