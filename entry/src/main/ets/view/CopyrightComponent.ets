import { CommonConstants } from '../common/constants/CommonConstants';

/**
 * Copyright component for splash screen page.
 */
@Component
export default struct CopyrightComponent {
  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_video'))
          .objectFit(ImageFit.Contain)
          .width($r('app.float.copy_right_image_width'))
          .height($r('app.float.copy_right_image_width'))

        Text($r('app.string.copyright_title'))
          .fontSize($r('app.float.copyrightArea_title_text_size'))
          .fontColor($r('app.color.title'))
          .margin({ left: $r('app.float.copyright_title_margin_left') })
          .align(Alignment.End)
      }

      Text($r('app.string.copyright'))
        .fontSize($r('app.float.copyright_description_text_size'))
        .margin({ top: $r('app.float.copyright_description_margin_top') })
        .align(Alignment.End)
        .fontColor($r('app.color.copyright_text'))
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.White)
    .width(CommonConstants.COPYRIGHT_AREA_COLUMN_WIDTH)
    .height($r('app.float.copy_right_area_height'))
  }
}
@Builder function overBuilder(paramA1: string) {
  Row() {
    Text(`UseStateVarByValue: ${paramA1} `)
  }
}