package cn.edu.jmu.judge.executor.thread;

import cn.edu.jmu.judge.entity.json.JudgeResultJson;
import cn.edu.jmu.judge.util.PythonJudgeUtil;
import lombok.extern.slf4j.Slf4j;

import java.util.concurrent.Callable;

/**
 * @author xeathen
 * @date 2019/10/01
 **/
@Slf4j
public class JudgeCallable implements Callable<JudgeResultJson> {

    private Integer solutionId;
    private Integer databaseId;



    private String answer;

    private String trueResult;

    private String sourceCode;

    public JudgeCallable(Integer solutionId, Integer databaseId, String answer, String trueResult, String sourceCode) {
        this.solutionId = solutionId;
        this.databaseId = databaseId;
        this.answer = answer;
        this.trueResult = trueResult;
        this.sourceCode = sourceCode;
    }

    @Override
    public JudgeResultJson call() {
        try {
            JudgeResultJson json = PythonJudgeUtil.sqlJudge(solutionId, databaseId, answer, trueResult, sourceCode);
            log.debug("判题结束");
            System.out.println("json:" + json);
            //log.debug(json.getMessage());
            return json;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Integer getSolutionId() {
        return this.solutionId;
    }

    public Integer getDatabaseId() {return  this.databaseId; }

    public String getAnswer() {
        return answer;
    }

    public String getTrueResult() {
        return trueResult;
    }

    public String getSourceCode() {
        return sourceCode;
    }
}
