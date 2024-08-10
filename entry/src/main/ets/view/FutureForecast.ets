import display from '@ohos.display'
import { DailyForecast, ForecastArray, FutureWeather } from '../common/model/Weather'
import { isDayTime, Point, pointsOnBezierCurves, simplifyDate, stringToRelativeDate } from '../utils'
import { curveToBezier } from '../utils/curve-to-bezier'
import hilog from '@ohos.hilog'
// import { testRetrofit } from '@ohos/retrofit'
import weatherViewModel from '../viewmodel/WeatherViewModel'

@Component
export default struct FutureForecast {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private offContext: OffscreenCanvasRenderingContext2D = new OffscreenCanvasRenderingContext2D(900, 300, this.settings)
  private path2Db: Path2D = new Path2D()
  scroller: Scroller = new Scroller()
  // @ObjectLink forecast: FutureWeather
  @Prop fcs: ForecastArray

  build() {

    Column() {
      Text('多日预报').fontColor(Color.White).align(Alignment.Start).margin({left:20,top:15}).opacity(0.8).fontSize($r('app.float.title'))
      Scroll(this.scroller) {
        Column() {
          Canvas(this.context)
            .width(px2vp(display.getDefaultDisplaySync().width)*2.0)
            .height('100%')
            .onReady(() => {
              // console.log('forecast',JSON.stringify(this.forecast))
              console.log('forecast', JSON.stringify(this.fcs))
              if (!this.fcs || this.fcs.length === 0) {
                // 处理 forecast.daily 为 undefined 或空数组的情况
                return
              }

              this.context.beginPath()
              this.context.lineWidth = 1
              this.context.lineCap = 'round'
              this.context.lineJoin = 'round'
              this.context.fillStyle = '#ffffff'
              this.context.strokeStyle = '#ffffff'
              const curTop = 105
              const curLeft = 40

              let highs:string[] = []
              let lows:string[] = []
              // const temperatureMaxes = this.fcs.map()
              const temperatureMaxes = this.fcs.map(forecast => forecast.tempMax);
              const temperatureMines = this.fcs.map(forecast => forecast.tempMin);

              highs.push(...temperatureMaxes)
              lows.push(...temperatureMines)

              const numericHighs = highs.map(temp => parseFloat(temp));
              const numericLows = lows.map(temp => parseFloat(temp));

              // 过滤掉无效的数字（如 NaN）
              const validHighs = numericHighs.filter(temp => !isNaN(temp));
              const validLows = numericLows.filter(temp => !isNaN(temp));

              const max = Math.max(...validHighs);
              const min = Math.min(...validLows);
              const unit = max - min
              const w = px2vp(display.getDefaultDisplaySync().width)
              let perGap = this.calculateMargin(5, w, curLeft)
              let remainSpace = this.calRemainingSpace(120, 20, 20)

              let highPs: [number, number][] = []
              let lowPs: [number, number][] = []
              for (let index = 0; index < highs.length; index++) {
                const element = highs[index];
                let y = this.calY(max - parseFloat(element), unit, remainSpace) + curTop // margin top
                let x = index * perGap + curLeft // margin left
                highPs.push([x, y])
              }

              for (let i = 0;i < highPs.length; i++) {
                const isDay = isDayTime(this.fcs[i].sunrise, this.fcs[i].sunset)
                let icon = this.fcs[i].iconDay
                if (!isDay) {
                  icon = this.fcs[i].iconNight
                }
                let img: ImageBitmap = new ImageBitmap(`icons/${icon}-fill.png`)
                this.context.drawImage(img, highPs[i][0] - 10, 60, 20, 20)
              }

              for (let index = 0; index < lows.length; index++) {
                const element = lows[index];
                let y = this.calY(max - parseInt(element), unit, remainSpace) + curTop // margin top
                let x = index * perGap + curLeft // margin left
                lowPs.push([x, y])
              }

              const x = highPs[0][0];
              const y = highPs[0][1];

              this.context.moveTo(x, y)
              let points = curveToBezier(highPs)

              for (let i = 1; i < points.length - 2; i += 3) {
                const controlPoint1 = points[i];
                const controlPoint2 = points[i + 1];
                const endPoint = points[i + 2];
                this.context.bezierCurveTo(
                  controlPoint1[0], controlPoint1[1],
                  controlPoint2[0], controlPoint2[1],
                  endPoint[0], endPoint[1]
                );
              }

              this.context.stroke()
              this.context.moveTo(x, y)
              let fp = getContext(this).resourceManager.getNumber($r('app.float.caption').id);
              for (let i = 0;i < highPs.length; i++) {
                this.context.beginPath() // 开始绘制路径
                this.context.lineWidth = 2 // 线条宽度
                this.context.strokeStyle = "#fff" // 描边颜色
                this.context.fillStyle = "#fff" // 描边颜色

                const isDay = isDayTime(this.fcs[i].sunrise, this.fcs[i].sunset)

                this.context.font = `${fp}px sans-serif`
                this.context.arc(highPs[i][0], highPs[i][1], 2, 0, 360)
                const temp = highs[i] + '°'
                const w = this.context.measureText(temp).width
                this.context.fillText(temp, highPs[i][0] - (w >> 1), highPs[i][1] - 10, 40)

                const date = stringToRelativeDate(this.fcs[i].fxDate)
                const dw = this.context.measureText(date).width
                this.context.fillText(date, highPs[i][0] - (dw >> 1), 15, 40)

                const timeStr = simplifyDate(this.fcs[i].fxDate)
                const tw = this.context.measureText(timeStr).width
                this.context.fillText(timeStr, highPs[i][0] - (tw >> 1), 40, 40)

                let quality = this.fcs[i].textDay
                if (!isDay) quality = this.fcs[i].textNight
                const qw = this.context.measureText(quality).width
                this.context.fillText(quality, highPs[i][0] - (qw >> 1), 240, 40)

                this.context.stroke() // 边框绘制
                this.context.closePath() // 结束绘制路径
              }

              const x1 = lowPs[0][0];
              const y1 = lowPs[0][1];
              this.context.moveTo(x1, y1)
              let points1 = curveToBezier(lowPs)
              this.context.lineWidth = 1 // 线条宽度
              this.context.strokeStyle = "#fff" // 描边颜色
              for (let i = 1; i < points1.length - 2; i += 3) {
                const controlPoint1 = points1[i];
                const controlPoint2 = points1[i + 1];
                const endPoint = points1[i + 2];

                this.context.bezierCurveTo(
                  controlPoint1[0], controlPoint1[1],
                  controlPoint2[0], controlPoint2[1],
                  endPoint[0], endPoint[1]
                );
              }

              this.context.stroke()

              this.context.moveTo(x1, y1)
              for (let i = 0;i < lowPs.length; i++) {
                this.context.beginPath() // 开始绘制路径
                this.context.lineWidth = 2 // 线条宽度
                this.context.strokeStyle = "#fff" // 描边颜色
                this.context.fillStyle = "#fff" // 描边颜色
                const temp = lows[i] + '°'
                const w = this.context.measureText(temp).width
                this.context.fillText(temp, lowPs[i][0] - (w >> 1), lowPs[i][1] + 20, 40)
                this.context.arc(lowPs[i][0], lowPs[i][1], 2, 0, 360)
                this.context.stroke() // 边框绘制
                this.context.closePath() // 结束绘制路径
              }
            }
            ).height(260)
        }
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBarColor(Color.Transparent)
      .edgeEffect(EdgeEffect.Spring)
      .height(300)

    }.width('100%')
    .alignItems(HorizontalAlign.Start )
    .height(320)
  }

  selectPoints(points: Point[], numPoints: number): Point[] {

    const selectedPoints: Point[] = [];
    // 固定左右两个点
    // selectedPoints.push(points[0]);
    // 计算中间的点的间隔
    const interval = Math.floor((points.length) / (numPoints - 1));
    // 选取中间的点
    for (let i = 0; i < points.length - 1; i += interval) {
      selectedPoints.push(points[i]);
    }
    selectedPoints.push(points[points.length - 1]);

    return selectedPoints;
  }

  calculateMargin(dataCount: number, width: number, margin: number): number {
    const totalWidth: number = width - (2 * margin); // 去除左右两边的 margin
    if (dataCount <= 1) {
      return 0; // 只有一个数据时，间距为 0
    }
    const interval: number = totalWidth / (dataCount - 1);
    return interval;
  }

  calRemainingSpace(height: number, topMargin: number, bottomMargin: number): number {
    const remainingSpace: number = height - topMargin - bottomMargin;
    return remainingSpace;
  }

  calY(curTem: number, unit: number, space: number): number {
    return ((curTem) / unit) * space
  }

  onPageShow() {
    hilog.debug(1, 'onPageShow', this.fcs.length + '')
    // this.test()
  }


  // test(){
  //   testRetrofit
  // }
}

