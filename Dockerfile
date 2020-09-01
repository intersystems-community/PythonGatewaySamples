ARG IMAGE=intersystemscommunity/irispy:latest
FROM ${IMAGE}

USER root

RUN apt-get update && apt-get install -y --no-install-recommends p7zip-full g++ \
	&& rm -rf /var/lib/apt/lists/*

RUN pip install sklearn tensorflow tensorflow_hub annoy

USER irisuser

ENV PHOTO_DIR=$ISC_PACKAGE_INSTALLDIR/photo
RUN mkdir -p $PHOTO_DIR

USER irisuser:irisowner

RUN wget -q http://vision.cs.utexas.edu/projects/finegrained/utzap50k/ut-zap50k-images.zip  -O /tmp/ut-zap50k-images.zip
RUN 7z x /tmp/ut-zap50k-images.zip -o$PHOTO_DIR
RUN chmod -R a+rX $PHOTO_DIR
RUN rm /tmp/ut-zap50k-images.zip

USER irisowner

ENV SRC_DIR=/home/irisowner

RUN wget -q https://pm.community.intersystems.com/packages/zpm/latest/installer -O $SRC_DIR/zpm.xml

COPY --chown=irisowner . $SRC_DIR

COPY --chown=irisuser index.html $ISC_PACKAGE_INSTALLDIR/csp/user/index.html
COPY --chown=irisuser recommend.html $ISC_PACKAGE_INSTALLDIR/csp/user/recommend.html
COPY --chown=irisuser Engin*.md $ISC_PACKAGE_INSTALLDIR/csp/user/
ADD --chown=irisuser https://strapdownjs.com/v/0.2/themes/united.min.css $ISC_PACKAGE_INSTALLDIR/csp/user/united.min.css
ADD --chown=irisuser https://cdn.jsdelivr.net/npm/marked/marked.min.js $ISC_PACKAGE_INSTALLDIR/csp/user/marked.min.js

RUN iris start $ISC_PACKAGE_INSTANCENAME && \
    /bin/echo -e " do \$system.OBJ.Load(\"$SRC_DIR/zpm.xml\", \"ck\")" \
            " do ##class(%File).Delete(\"$SRC_DIR/zpm.xml\")" \
            " zn \"PYTHON\"" \
            " do \$system.OBJ.ImportDir(\"$SRC_DIR/ml\", \"*.cls\", \"ck\", , 1)" \
            " do \$system.OBJ.ImportDir(\"$SRC_DIR/\", \"*.xml\", \"ck\")" \
            " set sc = ##class(ml.Installer).Setup()" \
            " zpm \"install dsw\"" \
            " halt" \
    | iris session $ISC_PACKAGE_INSTANCENAME && \
 iris stop $ISC_PACKAGE_INSTANCENAME quietly \
  && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal.log \
  && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/IRIS.WIJ \
  && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/iris.ids \
  && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/alerts.log \
  && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/journal/* \
  && rm -f $ISC_PACKAGE_INSTALLDIR/mgr/messages.log \
  && rm -rf $SRC_DIR/ml \
  && rm -rf $SRC_DIR/.git \
  && rm -f $SRC_DIR/*.* $SRC_DIR/Dockerfile $SRC_DIR/LICENSE \
  && touch $ISC_PACKAGE_INSTALLDIR/mgr/messages.log