package cn.edu.jmu.system.controller.user;

import cn.edu.jmu.common.response.BasicResponse;
import cn.edu.jmu.common.util.ResponseUtil;
import cn.edu.jmu.judge.entity.json.JudgeResultJson;
import cn.edu.jmu.judge.enums.JudgeResponseCodeEnum;
import cn.edu.jmu.judge.util.PythonJudgeUtil;
import cn.edu.jmu.system.controller.handler.ProblemCategoryStatusHandler;
import cn.edu.jmu.system.entity.*;
import cn.edu.jmu.system.entity.dto.*;
import cn.edu.jmu.system.service.*;
import cn.edu.jmu.system.service.converter.ProblemCategoryConverter;
import cn.edu.jmu.system.service.converter.UserConverter;
import cn.edu.jmu.system.service.enums.UserStatusEnum;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import lombok.extern.slf4j.Slf4j;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.util.ObjectUtils;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author sgh
 * @date 2019/8/27 下午2:53
 */
@RestController
@RequiresRoles(value = {"user"})
@RequestMapping("/api/user")
@Slf4j
public class UserOperationController {

    @Resource
    private UserService userService;

    @Resource
    private SolutionService solutionService;

    @Resource
    private UserProblemService userProblemService;

    @Resource
    private ProblemService problemService;

    @Resource
    private ProblemCategoryService problemCategoryService;

    @Resource
    private ProblemCollectionService problemCollectionService;

    /**
     * 获取登录用户的信息
     */
    @GetMapping(value = "/users/{id}")
    public ResponseEntity<BasicResponse> get(@PathVariable(value = "id") Integer id) {
        User user = userService.getById(id);
        UserDto userDto = UserConverter.toDto(user);
        Integer passed = userProblemService.countPassed(id, true);
        userDto.setSolved(passed);
        Integer submit = userProblemService.countSubmit(id);
        userDto.setSubmit(submit);
        return ResponseUtil.buildResponse("查询成功", userDto);
    }

    /**
     * 更改用户信息
     */
    @PutMapping(value = "/users/")
    public ResponseEntity<BasicResponse> update(@RequestBody UserDto userDto) {
        if (userDto.getId() == null) {
            return ResponseUtil.fail("用户id不能为空");
        }
        Subject subject = SecurityUtils.getSubject();
        User user = (User) subject.getPrincipal();
        if (user.getId().equals(userDto.getId())) {
            userDto.setStatus(user.getStatus());
            userDto.setUsername(user.getUsername());
            userDto.setStudentNo(user.getStudentNo());
            userDto.setEmail(user.getEmail());
            boolean success = userService.update(userDto);
            return ResponseUtil.buildResponse(success, "修改成功", "修改失败");
        } else {
            return ResponseUtil.fail("无法修改他人信息");
        }
    }

    /**
     * 用户查看自己提交的代码
     */
    @GetMapping(value = "/solutions/{id}")
    public ResponseEntity<BasicResponse> getCode(@PathVariable(value = "id") Integer id) {
        Subject subject = SecurityUtils.getSubject();
        User user = (User) subject.getPrincipal();
        Solution solution = solutionService.getById(id);
        if(ObjectUtils.isEmpty(solution)){
            System.out.println("solution为空");
            System.out.println(user.getIsAdmin());
        }
        if (!ObjectUtils.isEmpty(solution) && (solution.getUid().equals(user.getId()) || user.getIsAdmin() == 2)) {
//            SolutionCodeDto solutionCodeDto = SolutionConverter.toSolutionCodeDto(solution);
            return ResponseUtil.buildResponse(solution);
        } else {
            return ResponseUtil.fail("无权限");
        }
    }

    /**
     * 用户提交判题
     */
    @PostMapping(value = "/submit/{problemCategoryId}")
    public ResponseEntity<BasicResponse> submit(@PathVariable("problemCategoryId") Integer problemCategoryId, @RequestBody @Validated SolutionDto solutionDto) {
        Subject subject = SecurityUtils.getSubject();
        User user = (User) subject.getPrincipal();
        solutionDto.setUid(user.getId());
        solutionDto.setProblemCategoryId(problemCategoryId);
        //以下代码添加database_id
        Integer databaseId = problemService.getById(solutionDto.getPid()).getDatabaseId();

        Integer solutionId = solutionService.add(solutionDto, databaseId);
        Map<String, Integer> data = new HashMap<>();
        data.put("solutionId", solutionId);

        data.put("databaseId", databaseId);

        return ResponseUtil.buildResponse(data);
    }

    /**
     * 得到用户通过题目和尝试题目的集合
     */
    @GetMapping(value = "/category_progress/{problemCategoryId}")
    public ResponseEntity<BasicResponse> getProblemStatus(@PathVariable("problemCategoryId") Integer problemCategoryId) {
        Subject subject = SecurityUtils.getSubject();
        User user = (User) subject.getPrincipal();
        if (user == null) {
            return ResponseUtil.fail("您还未登录，请登录后再试！");
        } else {
            return ProblemCategoryStatusHandler.handle(problemCategoryId, problemCategoryService, () -> {
                Map<String, List<Integer>> data = new HashMap<>();
                data.put("accept", userProblemService.findByUserIdAndProblemCategoryIdAndPassed(user.getId(), problemCategoryId, true));
                data.put("try", userProblemService.findByUserIdAndProblemCategoryIdAndPassed(user.getId(), problemCategoryId, false));
                return ResponseUtil.buildResponse(data);
            });
        }
    }

    /**
     * 用户提交调试运行
     * TODO: 修改为题目集内题目的解答提交接口
     */
    @PostMapping(value = "/judgement")
    public ResponseEntity<BasicResponse> judge(@RequestBody @Validated SolutionDto solutionDto) {
        Integer databaseId = problemService.getById(solutionDto.getPid()).getDatabaseId();
        JudgeResultJson result = PythonJudgeUtil.getTrueResult(solutionDto.getSourceCode(), databaseId);
//        log.debug(result.toString());
        //以下两行代码解决前端显示unicode问题
        result.getData().setTrueResult(unicodeToString(result.getData().getTrueResult()));
        result.getData().setTrueResult(result.getData().getTrueResult().replace("u'", "'"));

        if (JudgeResponseCodeEnum.OK.getValue().equals(result.getCode())) {
            return ResponseUtil.buildResponse("执行成功", result.getData().getTrueResult());
        } else if (JudgeResponseCodeEnum.FAIL.getValue().equals(result.getCode())) {
            return ResponseUtil.fail("执行失败," + result.getMessage());
        } else if (JudgeResponseCodeEnum.NO_DB_FILE.getValue().equals(result.getCode())) {
            return ResponseUtil.fail("系统错误," + result.getMessage());
        }
        return ResponseUtil.fail("未知错误");
    }


    /**
     * 查询用户最后一次对某个题目提交的代码
     *
     * @param problemCategoryId 题目集ID
     * @param problemId         题目ID
     */
    @GetMapping(value = "/latest_solution/{problemCategoryId}/{problemId}")
    public ResponseEntity<BasicResponse> getLatestSolutionByUserIdAndProblemId(@PathVariable("problemCategoryId") Integer problemCategoryId, @PathVariable("problemId") Integer problemId) {
        Subject subject = SecurityUtils.getSubject();
        User user = (User) subject.getPrincipal();
        if (user == null) {
            return ResponseUtil.fail("您还未登录，请登录后再试！");
        } else {
            return ProblemCategoryStatusHandler.handle(problemCategoryId, problemCategoryService, () -> {
                Solution solution = solutionService.getLatestSubmittedSolution(user.getId(), problemCategoryId, problemId);
                if (solution == null) {
                    return ResponseUtil.fail("查询失败，无法找到该题目的提交记录！");
                } else {
                    return ResponseUtil.buildResponse("查询成功", solution);
                }
            });
        }
    }

    /**
     * @param problemCategoryId 题目集ID
     * @param problemId         题目集中题目的ID
     */
    @GetMapping(value = "/problem/{problemCategoryId}/{problemId}")
    public ResponseEntity<BasicResponse> selectProblemByCategoryIdAndProblemId(@PathVariable("problemCategoryId") Integer problemCategoryId, @PathVariable("problemId") Integer problemId) {
        return ProblemCategoryStatusHandler.handle(problemCategoryId, problemCategoryService, () -> {
            // 判断题目ID是否在题目集里，如果在，则查询对应的题目信息，如果不在，则抛出错误
            if (problemCollectionService.isExistByProblemIdAndProblemCategoryId(problemId, problemCategoryId)) {
                ProblemDetailToUserDto detailToUserDto = problemService.getToUserById(problemId);
                if (detailToUserDto == null) {
                    return ResponseUtil.fail("无法找到该题目或题目对应的数据库信息不存在！");
                } else {
                    return ResponseUtil.buildResponse("查询成功", detailToUserDto);
                }
            } else {
                return ResponseUtil.fail("该题目不在此题目集中！");
            }
        });
    }

    /**
     * 通过题目集ID查询题目集的基础信息
     *
     * @param problemCategoryId 题目集ID
     */
    @GetMapping(value = "/problem-category/{problemCategoryId}")
    public ResponseEntity<BasicResponse> selectProblemCategoryById(@PathVariable("problemCategoryId") Integer problemCategoryId) {
        ProblemCategory problemCategory = problemCategoryService.getById(problemCategoryId);
        if (problemCategory == null) {
            return ResponseUtil.fail("该ID所对应的题目集不存在！");
        }
        ProblemCategoryDto problemCategoryDto = ProblemCategoryConverter.problemCategoryDto(problemCategory);
        return ResponseUtil.buildResponse("查询成功", problemCategoryDto);
    }

    /**
     * 题目集对应的排行榜
     * 用户名 学号 通过数 提交数 通过率
     * UserDto
     */
    @GetMapping(value = "/rank/{problemCategoryId}")
    public ResponseEntity<BasicResponse> getRankList(@PathVariable("problemCategoryId") Integer problemCategoryId, UserProblemDto userProblemDto, @RequestParam(defaultValue = "1") Integer pageNum, @RequestParam(defaultValue = "10") Integer pageSize) {
        return ProblemCategoryStatusHandler.handle(problemCategoryId, problemCategoryService, () -> {
            Page<UserProblem> page = new Page<>(pageNum, pageSize);
            userProblemDto.setProblemCategoryId(problemCategoryId);
            IPage<UserProblemDto> iPage = userProblemService.getAll(userProblemDto, page);
            return ResponseUtil.buildResponse("查询成功", iPage);
        });
    }

    /**
     * 排行榜
     * 用户名 学号 通过数 提交数 通过率
     * UserDto
     */
    @GetMapping(value = "/base_rank")
    public ResponseEntity<BasicResponse> getRank(UserProblemDto userProblemDto, @RequestParam(defaultValue = "1") Integer pageNum, @RequestParam(defaultValue = "10") Integer pageSize) {
        System.out.println(123);
        Page<UserProblem> page = new Page<>(pageNum, pageSize);
        IPage<UserProblemDto> iPage = userProblemService.getRank(userProblemDto, page);
        return ResponseUtil.buildResponse("查询成功", iPage);
    }

    /**
     * 通过题目集ID查询题目集包含的题目列表
     */
    @GetMapping(value = "/problem-collection/{problemCategoryId}")
    public ResponseEntity<BasicResponse> selectProblemCategoryDetail(@PathVariable("problemCategoryId") Integer problemCategoryId, @RequestParam(defaultValue = "1") Integer pageNum, @RequestParam(defaultValue = "10") Integer pageSize) {
        return ProblemCategoryStatusHandler.handle(problemCategoryId, problemCategoryService, () -> {
            Page<ProblemCollection> page = new Page<>(pageNum, pageSize);
            ProblemCollectionDto problemCollectionDto = new ProblemCollectionDto();
            problemCollectionDto.setCategoryId(problemCategoryId);
            IPage<ProblemCollectionDto> iPage = problemCollectionService.search(problemCollectionDto, page);
            return ResponseUtil.buildResponse("查询成功", iPage);
        });
    }

    /**
     * 查询categoryId对应的题目集的提交状态
     */
    @GetMapping(value = "/submit_status/{problemCategoryId}")
    public ResponseEntity<BasicResponse> getSubmitStatus(@PathVariable("problemCategoryId") Integer problemCategoryId, SolutionDto solutionDto, @RequestParam(defaultValue = "1") Integer pageNum, @RequestParam(defaultValue = "10") Integer pageSize) {
        return ProblemCategoryStatusHandler.handle(problemCategoryId, problemCategoryService, () -> {
            Page<Solution> page = new Page<>(pageNum, pageSize);
            solutionDto.setProblemCategoryId(problemCategoryId);
            IPage<SolutionDto> iPage = solutionService.getAll(solutionDto, page);
            return ResponseUtil.buildResponse("查询成功", iPage);
        });
    }

    /**
     * 查询categoryId 和problemId对应的提交状态
     *
     */
    @GetMapping(value = "problem-submit/{problemCategoryId}/{problemId}")
    public  ResponseEntity<BasicResponse> getproblemSubmitStatus(@PathVariable("problemCategoryId") Integer problemCategoryId, @PathVariable("problemId") Integer problemId, SolutionDto solutionDto, @RequestParam(defaultValue = "1")Integer pageNum, @RequestParam(defaultValue = "10") Integer pageSize) {
        return ProblemCategoryStatusHandler.handle(problemCategoryId, problemCategoryService, () -> {
            Page<Solution> page = new Page<>(pageNum, pageSize);
            solutionDto.setProblemCategoryId(problemCategoryId);
            solutionDto.setPid(problemId);
            IPage<SolutionDto> iPage = solutionService.getAll(solutionDto, page);
            return ResponseUtil.buildResponse("查询成功", iPage);
        });
    }

    public static String unicodeToString(String unicodeStr){
        StringBuilder sb = new StringBuilder();
        int i = -1;
        int pos = 0;
        //在pos及之后搜索\\u
        while((i = unicodeStr.indexOf("\\u", pos)) != -1) {
            sb.append(unicodeStr.substring(pos, i));

            if((i+5) < unicodeStr.length()){
                String unicode = unicodeStr.substring(i + 2, i + 6);
                sb.append((char) Integer.parseInt(unicode, 16));
                pos = i + 6;
            } else {
                sb.append(unicodeStr.substring(i, unicodeStr.length()));
                return sb + "";
            }
        }
        return sb + "" + unicodeStr.substring(pos, unicodeStr.length());
    }
}
