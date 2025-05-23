package cn.edu.jmu.system.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;

/**
 * @author xeathen
 * @date 2019/10/5 10:25
 */
@Data
@TableName(value = "user_problems")
public class UserProblem implements Serializable {

    private static final long serialVersionUID = -3270267373811937646L;

    /**
     * ID
     */
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    /**
     * 用户ID
     */
    @TableField(value = "uid")
    private Integer uid;

    /**
     * 题目集ID
     */
    @TableField("pcid")
    private Integer problemCategoryId;

    /**
     * 题目ID
     */
    @TableField(value = "pid")
    private Integer pid;

    /**
     * 状态
     */
    @TableField(value = "passed")
    private Boolean passed;

    /**
     * 通过数量
     */
    @TableField(value = "submit")
    private Integer submit;

    public Integer getSubmit() {
        return submit;
    }
}
