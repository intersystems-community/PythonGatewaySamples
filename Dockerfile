FROM intersystemscommunity/irispy:latest

RUN pip install sklearn

RUN mkdir -p /tmp/deps \
 && cd /tmp/deps \
 && wget -q https://pm.community.intersystems.com/packages/zpm/latest/installer -O zpm.xml

ENV SRC_DIR=/tmp/src

COPY . $SRC_DIR

COPY index.html $ISC_PACKAGE_INSTALLDIR/csp/user/index.html
ADD https://strapdownjs.com/v/0.2/themes/united.min.css $ISC_PACKAGE_INSTALLDIR/csp/user/united.min.css
ADD https://cdn.jsdelivr.net/npm/marked/marked.min.js $ISC_PACKAGE_INSTALLDIR/csp/user/marked.min.js


RUN iris start $ISC_PACKAGE_INSTANCENAME && \
    /bin/echo -e " do \$system.OBJ.Load(\"/tmp/deps/zpm.xml\", \"ck\")" \
            " zn \"PYTHON\"" \
            " do \$system.OBJ.ImportDir(\"$SRC_DIR/ml\", \"*.cls\", \"ck\", , 1)" \
            " do \$system.OBJ.ImportDir(\"$SRC_DIR/\", \"*.xml\", \"ck\")" \
            " do ##class(ml.Installer).ConfigureProduction()" \
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
  && rm -rf $SRC_DIR