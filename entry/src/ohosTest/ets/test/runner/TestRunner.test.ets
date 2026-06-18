import designTokensTest from '../common/DesignTokens.test';
import constantsTest from '../common/Constants.test';
import errorFormatterTest from '../common/ErrorFormatter.test';
import appLoggerTest from '../common/AppLogger.test';
import appStorageBootstrapTest from '../common/AppStorageBootstrap.test';

export default function testRunner() {
  designTokensTest();
  constantsTest();
  errorFormatterTest();
  appLoggerTest();
  appStorageBootstrapTest();
}
