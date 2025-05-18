package cn.edu.jmu.judge.service.impl;

import cn.edu.jmu.judge.entity.json.JudgeResultJson;
import cn.edu.jmu.judge.enums.JudgeResponseCodeEnum;
import cn.edu.jmu.judge.executor.ThreadPoolUtils;
import cn.edu.jmu.judge.executor.thread.JudgeCallable;
import cn.edu.jmu.judge.service.JudgeService;
import cn.edu.jmu.judge.util.Md5Util;
import cn.edu.jmu.judge.util.PythonJudgeUtil;
import cn.edu.jmu.system.entity.*;
import cn.edu.jmu.system.entity.dto.SolutionDto;
import cn.edu.jmu.system.mapper.ProblemMapper;
import cn.edu.jmu.system.mapper.SolutionMapper;
import cn.edu.jmu.system.service.ProblemCollectionService;
import cn.edu.jmu.system.service.ProblemService;
import cn.edu.jmu.system.service.UserProblemService;
import cn.edu.jmu.system.service.UserService;
import cn.edu.jmu.system.service.converter.SolutionConverter;
import cn.edu.jmu.system.service.enums.SolutionResultEnum;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Optional;
import java.util.concurrent.FutureTask;

/**
 * @author xeathen
 * @date 2019/9/7 16:45
 */
@Service
public class JudgeServiceImpl extends ServiceImpl<SolutionMapper, Solution> implements JudgeService {

    @Resource
    private UserService userService;

    @Resource
    private UserProblemService userProblemService;

    @Resource
    private ProblemService problemService;

    @Resource
    private ProblemCollectionService problemCollectionService;


    /**
     * 判题
     *
     * @param solutionDto
     * @return boolean
     */
    @Override
    public boolean judge(SolutionDto solutionDto, Integer databaseId) {
        //判断solutionId是否合法
        if (baseMapper.selectById(solutionDto.getId()) == null) {
            return false;
        }
        //调用线程池判题
        Integer problemId = baseMapper.getProblemId(solutionDto.getId());

        String sourceCode = baseMapper.getSourceCode(solutionDto.getId());

        String answer = baseMapper.getProblemAnswer(problemId);

        String trueResult = baseMapper.getTrueResult(problemId);

        JudgeResultJson result = executeTask(solutionDto.getId(), databaseId, answer, trueResult, sourceCode);
        //判题脚本结束
        Solution solution = SolutionConverter.toEntity(solutionDto);
        if (result != null) {
            String code = result.getCode();
            String resultCode = result.getData().getResult();
            String runError = result.getData().getRunError();
            //检查UserProblem表，插入记录
            Integer uid = solution.getUid();
            Integer pid = solution.getPid();
            Integer pcid = solution.getProblemCategoryId();
            UserProblem userProblem = new UserProblem();
            userProblem.setUid(uid);
            userProblem.setPid(pid);
            userProblem.setProblemCategoryId(pcid);
            User user = userService.getById(uid);
            Problem problem = problemService.getById(pid);
            Integer userProblemId = userProblemService.find(uid, pid);
            UserProblem userProblem1 = userProblemService.getById(userProblemId);
            Integer problemCollectionId = problemCollectionService.findByProblemIdAndProblemCategoryId(pid, pcid);
            ProblemCollection problemCollection = problemCollectionService.getById(problemCollectionId);
            if (JudgeResponseCodeEnum.OK.getValue().equals(code)) {
                if (SolutionResultEnum.ACCEPTED.getValue().equals(resultCode)) {
                    solution.setResult(SolutionResultEnum.ACCEPTED);
                    if (userProblemService.find(uid, pid, true) == 0) {
//                        increaseSolvedCount(user, problem);
                    }
                    if (userProblemId != 0) {
                        userProblem.setId(userProblemId);
                    }
                    if (problemCollectionId != 0) {
                        problemCollection.setProblemSolved(problemCollection.getProblemSolved() + 1);
                        problemCollection.setProblemSubmit(problemCollection.getProblemSubmit() + 1);
                    }
                    userProblem.setPassed(true);
                    if(Optional.ofNullable(userProblem1).isPresent()){
                        userProblem.setSubmit(userProblem1.getSubmit() + 1);
                    }else{
                        userProblem.setSubmit(1);
                    }

                } else {
                    if (SolutionResultEnum.COMPILE_ERROR.getValue().equals(resultCode)) {
                        solution.setResult(SolutionResultEnum.COMPILE_ERROR);
                    } else if (SolutionResultEnum.WRONG_ANSWER.getValue().equals(resultCode)) {
                        solution.setResult(SolutionResultEnum.WRONG_ANSWER);
                    } else {
                        solution.setResult(SolutionResultEnum.UNKNOWN);
                    }
                    if (runError != null) {
                        solution.setRunError(runError);
                    }
                    if (userProblemId == 0) {
                        userProblem.setPassed(false);
                    } else {
                        userProblem.setId(userProblemId);
                    }
                    if (problemCollectionId != 0) {
                        problemCollection.setProblemSubmit(problemCollection.getProblemSubmit() + 1);
                    }
                    if(Optional.ofNullable(userProblem1).isPresent()){
                        userProblem.setSubmit(userProblem1.getSubmit() + 1);
                    }else{
                        userProblem.setSubmit(1);
                    }
                }
//                increaseSubmitCount(user, problem);
            } else if (JudgeResponseCodeEnum.FAIL.getValue().equals(code)) {
                baseMapper.deleteById(solution.getId());
                return false;
            } else if (JudgeResponseCodeEnum.NO_DB_FILE.getValue().equals(code)) {
                baseMapper.deleteById(solution.getId());
                return false;
            }
            userProblemService.saveOrUpdate(userProblem);
            baseMapper.updateById(solution);
            userService.saveOrUpdate(user);
            problemService.saveOrUpdate(problem);
            problemCollectionService.saveOrUpdate(problemCollection);
            return true;
        } else {
            baseMapper.deleteById(solution.getId());
            return false;
        }
    }

    /**
     * 获取正确答案
     *
     * @param answer
     * @param databaseId
     * @return boolean
     */
    @Override
    public String getTrueResult(String answer, Integer databaseId) {
        JudgeResultJson judgeResultJson = PythonJudgeUtil.getTrueResult(answer, databaseId);
        log.debug(judgeResultJson.toString());
        if (JudgeResponseCodeEnum.OK.getValue().equals(judgeResultJson.getCode())) {
            return judgeResultJson.getData().getTrueResult();
        }
        return null;
    }

    /**
     * 获取正确答案的Md5值
     *
     * @param answer
     * @param databaseId
     * @return boolean
     */
    @Override
    public JudgeResultJson getTrueResultMd5(String answer, Integer databaseId) {
        JudgeResultJson judgeResultJson = PythonJudgeUtil.getTrueResult(answer, databaseId);
        log.debug(judgeResultJson.toString());
        if (JudgeResponseCodeEnum.OK.getValue().equals(judgeResultJson.getCode())) {
            judgeResultJson.getData().setTrueResult(Md5Util.getStringMd5(judgeResultJson.getData().getTrueResult()));
            return judgeResultJson;
        }
        return judgeResultJson;
    }

//    private void increaseSubmitCount(User user, Problem problem) {
//        user.setSubmit(user.getSubmit() + 1);
//        problem.setSubmit(problem.getSubmit() + 1);
//    }

//    private void increaseSolvedCount(User user, Problem problem) {
//        user.setSolved(user.getSolved() + 1);
//        problem.setSolved(problem.getSolved() + 1);
//    }

    private JudgeResultJson executeTask(Integer solutionId, Integer databaseId, String answer, String trueResult, String sourceCode) {
        JudgeResultJson result = null;
        try {
            //添加database_id
//            FutureTask<JudgeResultJson> futureTask = new FutureTask<>(new JudgeCallable(solutionId));
            FutureTask<JudgeResultJson> futureTask = new FutureTask<>(new JudgeCallable(solutionId, databaseId, answer, trueResult, sourceCode));

            ThreadPoolUtils.getInstance().submit(futureTask);
            result = futureTask.get();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
