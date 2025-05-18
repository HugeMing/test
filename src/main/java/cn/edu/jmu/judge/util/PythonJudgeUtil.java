package cn.edu.jmu.judge.util;

import cn.edu.jmu.common.util.OSUtil;
import cn.edu.jmu.judge.entity.json.JudgeResultJson;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import lombok.extern.slf4j.Slf4j;

import javax.xml.ws.Response;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 判题工具类
 *
 * @author xeathen
 * @date 2019/9/8 10:47
 */
@Slf4j
public class PythonJudgeUtil {

    /**
     * 调用Python脚本创建数据库
     *?
     * @param databaseId
     * @return judgeResultJson
     */
    public static JudgeResultJson createDatabase(Integer databaseId, String createTable, String testData) {
        String pythonCommand = "python3";
        if (OSUtil.isWindows()) {
            pythonCommand = "python";
        }
        String[] args = new String[]{pythonCommand, "/home/ubuntu/judger/createSqlite3Database.py", String.valueOf(databaseId), createTable, testData};
        //String[] args = new String[]{pythonCommand, "./judger/createSqlite3Database.py", String.valueOf(databaseId), createTable, testData};
        log.debug("开始创建数据库");
        return pythonAction(args);
    }

    /**
     * 调用Python脚本获取正确答案
     *
     * @param answer
     * @param databaseId
     * @return
     */
    public static JudgeResultJson getTrueResult(String answer, Integer databaseId) {
        String pythonCommand = "python3";
        if (OSUtil.isWindows()) {
            pythonCommand = "python";
        }
        String[] args = new String[]{pythonCommand, "/home/ubuntu/judger/getTrueResultByProblemAnswer.py", answer, String.valueOf(databaseId)};
        //String[] args = new String[]{pythonCommand, "./judger/getTrueResultByProblemAnswer.py", answer, String.valueOf(databaseId)};
        log.debug("开始获取正确答案begin get right answer");

//        for(int i = 0; i < args.length; i++) {
//            System.out.println(args[i]);
//        }
        return pythonAction(args);
    }

    /**
     * 调用Python脚本进行判题
     *
     * @param solutionId
     * @return judgeResultJson
     */
    public static JudgeResultJson sqlJudge(Integer solutionId, Integer databaseId, String answer, String trueResult, String sourceCode) {
        String pythonCommand = "python3";
        if (OSUtil.isWindows()) {
            pythonCommand = "python";
        }
        String[] args = new String[]{pythonCommand, "/home/ubuntu/judger/judger.py", String.valueOf(solutionId), String.valueOf(databaseId), answer, trueResult, sourceCode};
        //String[] args = new String[]{pythonCommand, "./judger/judger.py", String.valueOf(solutionId)};
        log.debug("开始判题");
        for(int i = 0; i < args.length; i++) {
            System.out.println(args[i]);
        }
        return pythonAction(args);
    }

    /**
     * 调用Python脚本
     *
     * @param args
     * @return judgeResultJson
     */
    private static JudgeResultJson pythonAction(String[] args) {
        try {
            // 执行py文件
            Process proc = Runtime.getRuntime().exec(args);
            BufferedReader in = new BufferedReader(new InputStreamReader(proc.getInputStream(), "UTF8"));
            String message = "";
            String line = null;
            while ((line = in.readLine()) != null) {
                message += line;
            }
            message = unicodeToString(message);
            System.out.println(message);
            JudgeResultJson json = new Gson().fromJson(message, JudgeResultJson.class);

//            if ((in.readLine()["data"]) != null) {
//                return new Gson().fromJson(line, JudgeResultJson.class);
//            }else {
//                System.out.println("line is null");
//            }
            in.close();
            proc.waitFor();
            return json;
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
        return null;
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
