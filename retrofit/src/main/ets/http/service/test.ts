
import { BaseService, RequestInterceptorFunction, Response, ResponseInterceptorFunction, ServiceBuilder } from '../retrofit/retrofit';
import { BasePath, Body, GET, GraphQL, Headers, POST, QueryMap } from '../retrofit/decorators';
import hilog from '@ohos.hilog';
import axios, { AxiosError, AxiosResponse } from '@ohos/axios';

export class SearchQuery {
  location?: string = '118.29,33.95';
  key?: string = 'fa4b35009fe94c9cbc9512977055fcb9';
}

export const v =
  `query {
  detail: getIMConfig {
    enabled
  }
}`;

const query = '{query:query getIMConfig {  detail: getIMConfig {   enabled  }}   ,operationName:getIMConfig}'


@BasePath("")
class ItemService extends BaseService {
  @GET("/v7/weather/10d?location=118.29,33.95&key=fa4b35009fe94c9cbc9512977055fcb9")
  async getNow(@QueryMap query:SearchQuery): Promise<Response> {
    // @ts-ignore
    return <Response> {}
  };
}
@BasePath("")
class LcService extends BaseService {
  @POST("/graphql/im/")
  @GraphQL(v)
  async getIm( _body:String): Promise<Response> {
    // @ts-ignore
    return <Response> {}
  };
}

export const RequestInterceptor: RequestInterceptorFunction = (config) => {
  console.log("Before sending request to server.");
  return config;
};

export const ResponseInterceptor: ResponseInterceptorFunction = (response) => {
  console.log("After receiving response from server.");
  return response;
};

export const testRetrofit = (async () => {
  const itemService = new ServiceBuilder()
    .setEndpoint('https://api.qweather.com')
    .setStandalone(true)
    .setRequestInterceptors(RequestInterceptor)
    .setResponseInterceptors(ResponseInterceptor)
    .build(ItemService);
  const response: any = await itemService.getNow(new SearchQuery());
  hilog.debug(1200,'testRetrofit', JSON.stringify(response));
  hilog.debug(1200,'testRetrofit', response.data);


  // 发送一个get请求（默认请求方式）
  // axios.get<string, AxiosResponse<string>, null>('https://api.qweather.com/v7/weather/10d', { params: { location: "118.29,33.95",key:'fa4b35009fe94c9cbc9512977055fcb9' } })
  //   .then((response: AxiosResponse) => {
  //     console.info("result:" + JSON.stringify(response.data));
  //   })
  //   .catch((error: AxiosError) => {
  //     console.error("result:" + error.message);
  //   });

  // 发送一个get请求
  // axios<string, AxiosResponse<string>, null>({
  //   method: "get",
  //   url: 'https://api.qweather.com/v7/weather/10d?location=118.29,33.95&key=fa4b35009fe94c9cbc9512977055fcb9'
  // }).then((res: AxiosResponse) => {
  //   console.info('result:' + JSON.stringify(res.data));
  // }).catch((error: AxiosError) => {
  //   console.error(error.message);
  // })
})();

// The common path of ItemService is ${ENDPOINT}/api/v1
