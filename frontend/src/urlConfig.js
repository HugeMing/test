//const ApiHost = process.env.VUE_APP_API_HOST ? process.env.VUE_APP_API_HOST : 'http://106.75.233.117:9999';
//const ApiHost = process.env.VUE_APP_API_HOST ? process.env.VUE_APP_API_HOST : 'http://47.107.237.15:9999';
const ApiHost = process.env.VUE_APP_API_HOST ? process.env.VUE_APP_API_HOST : 'http://121.40.74.201:9999';
const BaseUrl = ApiHost + "/api/user";
const Url = {
  // 用户登录接口
  login: ApiHost + "/api/user/auth",
  // 题目基础接口
  problemBaseUrl: BaseUrl + "/problem",
  //整体排行榜
  rankUrl: BaseUrl + "/base_rank/",
  // 题目集下面的排行榜基础接口
  rankListBaseUrl: BaseUrl + "/rank/",
  // 用户提交基础接口
  solutionBaseUrl: ApiHost + "/api/public/solutions",
  // 数据库基础接口
  databaseBaseUrl: BaseUrl + "/public/databases",
  // 获取用户详细信息接口
  userDetail: BaseUrl + "/users/",
  // 获取用户提交代码接口
  solutionCode: BaseUrl + "/solutions/",
  // 用户提交解答接口
  solutionSubmit: BaseUrl + "/submit/",
  // 获取用户通过和尝试过的题目列表
  userCategoryProgress: BaseUrl + "/category_progress/",
  // 运行调试SQL代码接口
  runCode: BaseUrl + "/judgement/",
  // 获取用户对某一题目最后一次提交详情结构
  latestSolution: BaseUrl + "/latest_solution/",
  problemCategoryListUrl: ApiHost + "/api/public/problem-category/",
  problemCategoryBaseUrl: BaseUrl + "/problem-category/",
  problemCollectionBaseUrl: BaseUrl + "/problem-collection/",
  //提交状态
  submitStatusUrl: BaseUrl + "/submit_status/",
  //题目集下某个题目的提交状态
  problemSubmitStatus: BaseUrl + "/problem-submit/"
};
export default Url;
