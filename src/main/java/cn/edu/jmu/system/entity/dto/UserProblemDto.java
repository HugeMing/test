package cn.edu.jmu.system.entity.dto;

import java.io.Serializable;

public class UserProblemDto implements Serializable {

    private static final long serialVersionUID = -8322780947820151796L;

    /**
     * 排名
     */
    private Integer rank;

    /**
     * 题目集ID
     */
    private Integer problemCategoryId;

    /**
     * 用户ID
     */
    private Integer uid;

    /**
     * 用户名
     */
    private String username;

    /**
     * 学号
     */
    private String studentNo;

    /**
     * 通过数
     */
    private Integer solved;

    /**
     * 提交数
     */
    private Integer submit;

    public Integer getRank() {
        return rank;
    }

    public void setRank(Integer rank) {
        this.rank = rank;
    }

    public Integer getProblemCategoryId() {
        return problemCategoryId;
    }

    public void setProblemCategoryId(Integer problemCategoryId) {
        this.problemCategoryId = problemCategoryId;
    }

    public Integer getUid() {
        return uid;
    }

    public void setUid(Integer uid) {
        this.uid = uid;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getStudentNo() {
        return studentNo;
    }

    public void setStudentNo(String studentNo) {
        this.studentNo = studentNo;
    }

    public Integer getSolved() {
        return solved;
    }

    public void setSolved(Integer solved) {
        this.solved = solved;
    }

    public Integer getSubmit() {
        return submit;
    }

    public void setSubmit(Integer submit) {
        this.submit = submit;
    }
}
