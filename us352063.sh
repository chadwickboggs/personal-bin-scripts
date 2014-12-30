#!/bin/bash

scp -q NWT_Core_Services/src/main/webapp/WEB-INF/enunciate.xml jenkins@ossdev01:~/tmp/US352063/NWT_Core_Services/src/main/webapp/WEB-INF/. && \
scp -q NWT_Core_UI/src/main/webapp/WEB-INF/enunciate.xml jenkins@ossdev01:~/tmp/US352063/NWT_Core_UI/src/main/webapp/WEB-INF/. && \
scp -q NWT_Core_Utils/pom.xml jenkins@ossdev01:~/tmp/US352063/NWT_Core_Utils/.
scp -q NWT_Core_Analyzer/src/test/java/com/comcast/cable/oss/watchtower/analyzer/grid/task/legacystb/sa/SALegacySTBNodeDataAnalyzerTest.java \
       jenkins@ossdev01:~/tmp/US352063/NWT_Core_Analyzer/src/test/java/com/comcast/cable/oss/watchtower/analyzer/grid/task/legacystb/sa/. && \
scp -q NWT_Core_Services/src/test/java/com/comcast/cable/oss/watchtower/service/user/UserServiceTest.java \
       jenkins@ossdev01:~/tmp/US352063/NWT_Core_Services/src/test/java/com/comcast/cable/oss/watchtower/service/user/.

echo $?
