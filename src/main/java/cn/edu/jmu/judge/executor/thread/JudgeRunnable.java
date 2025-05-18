package cn.edu.jmu.judge.executor.thread;

import cn.edu.jmu.judge.entity.json.JudgeResultJson;
import cn.edu.jmu.judge.util.PythonJudgeUtil;
import lombok.extern.slf4j.Slf4j;

/**
 * @author xeathen
 * @date 2019/10/5 15:59
 */
@Slf4j
public class JudgeRunnable implements Runnable {

    private Integer solutionId;
    private Integer databaseId;


    private String answer;

    private String trueResult;

    private String sourceCode;

    public JudgeRunnable(Integer solutionId, Integer databaseId, String answer, String trueResult, String sourceCode) {
        this.solutionId = solutionId;
        this.databaseId = databaseId;
        this.answer = answer;
        this.trueResult = trueResult;
        this.sourceCode = sourceCode;
    }

    @Override
    public void run() {
        try {
            JudgeResultJson json = PythonJudgeUtil.sqlJudge(solutionId, databaseId, answer, trueResult, sourceCode);
            log.debug("判题结束");
            log.debug(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Integer getSolutionId() {
        return this.solutionId;
    }
    public Integer getDatabaseId() { return  this.databaseId; }


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
