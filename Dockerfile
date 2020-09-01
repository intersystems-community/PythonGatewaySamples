ARG IMAGE=intersystemscommunity/irispy:latest
FROM ${IMAGE}

USER root

RUN apt-get update && apt-get install -y --no-install-recommends p7zip-full g++ \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /opt/irisapp
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp
COPY irissession.sh /
RUN chmod +x /irissession.sh 

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

USER irisuser

ENV PHOTO_DIR=$ISC_PACKAGE_INSTALLDIR/photo
RUN mkdir -p $PHOTO_DIR \
    && wget -q http://vision.cs.utexas.edu/projects/finegrained/utzap50k/ut-zap50k-images.zip  -O /tmp/ut-zap50k-images.zip \
    && 7z x /tmp/ut-zap50k-images.zip -o$PHOTO_DIR ut-zap50k-images/Shoes/* \
    && rm -f /tmp/ut-zap50k-images.zip

USER irisowner

ENV SRC_DIR=/home/irisowner

RUN wget -q https://pm.community.intersystems.com/packages/zpm/latest/installer -O $SRC_DIR/zpm.xml

COPY --chown=irisowner . $SRC_DIR

COPY --chown=irisuser index.html $ISC_PACKAGE_INSTALLDIR/csp/user/index.html
COPY --chown=irisuser recommend.html $ISC_PACKAGE_INSTALLDIR/csp/user/recommend.html
COPY --chown=irisuser Engin*.md $ISC_PACKAGE_INSTALLDIR/csp/user/
ADD --chown=irisuser https://strapdownjs.com/v/0.2/themes/united.min.css $ISC_PACKAGE_INSTALLDIR/csp/user/united.min.css
ADD --chown=irisuser https://cdn.jsdelivr.net/npm/marked/marked.min.js $ISC_PACKAGE_INSTALLDIR/csp/user/marked.min.js

SHELL ["/irissession.sh"]

RUN \
  set dir = ##class(%File).NormalizeDirectory($system.Util.GetEnviron("SRC_DIR")) \
  do $system.OBJ.Load(dir _ "zpm.xml", "ck") \
  zn "PYTHON" \
  do $system.OBJ.ImportDir(dir _ "ml", "*.cls", "ck", , 1) \
  do $system.OBJ.ImportDir(dir, "*.xml", "ck") \
  set sc = ##class(ml.Installer).Setup() \
  zpm "install dsw"

# bringing the standard shell back
SHELL ["/bin/bash", "-c"]

