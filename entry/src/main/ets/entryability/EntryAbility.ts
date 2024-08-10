import type AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import type Want from '@ohos.app.ability.Want';
import type window from '@ohos.window';

/**
 * Lift cycle management of Ability.
 */
export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');







     // 1.获取应用主窗口。
        let windowClass = null;
        windowStage.getMainWindow((err, data) => {
          if (err.code) {
            console.error('Failed to obtain the main window. Cause: ' + JSON.stringify(err));
            return;
          }
          windowClass = data;
          console.info('Succeeded in obtaining the main window. Data: ' + JSON.stringify(data));

          // 2.实现沉浸式效果：设置导航栏、状态栏不显示。
          let names = [];
          windowClass.setWindowSystemBarEnable(names, (err) => {
            if (err.code) {
              console.error('Failed to set the system bar to be visible. Cause:' + JSON.stringify(err));
              return;
            }
            // 设置成全屏
            windowClass.setWindowLayoutFullScreen(true)
            // 隐藏状态栏显示
            windowClass.setWindowSystemBarEnable(['status'])
            console.info('Succeeded in setting the system bar to be visible.');
          });})

    windowStage.loadContent("pages/SplashScreenPage", (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });

  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}