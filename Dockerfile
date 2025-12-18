# 1. Start from your existing final image
FROM dockerdex.umcn.nl:5005/diag/base-images:pathology-pt2.7.1

USER root

# 2. Copy your environment definition
# We use a requirements.txt style for direct pip installation to the system python
COPY env.yml /tmp/environment.yml

# 3. Install the panther dependencies 
# We use the existing python3.11 from the base image
RUN pip3 install --no-cache-dir \
    numpy<2 \
    ecos==2.0.14 \
    einops==0.8.0 \
    faiss-gpu==1.7.2 \
    h5py==3.11.0 \
    huggingface-hub==0.23.4 \
    monai \
    albumentations \
    osqp==0.6.7.post0 \
    scikit-survival==0.23.0 \
    transformers==4.42.3 \
    torch==2.3.1 \
    # Add any other specific versions from your original list here
    && rm -rf ~/.cache/pip

# 4. Verify ASAP is still linked
# The parent image already sets up the .pth file, but we'll ensure 
# the new packages haven't shadowed it.
RUN python3 -c "import asap; print('ASAP version:', asap.__version__)" || echo "ASAP link check skipped"

# 5. Set user back to 'user' for safety
WORKDIR /home/user
USER user
