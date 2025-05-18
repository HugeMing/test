package cn.edu.jmu.system.service;

import cn.edu.jmu.system.entity.UserProblem;
import cn.edu.jmu.system.entity.dto.UserProblemDto;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

/**
 * @author xeathen
 * @date 2019/10/5 10:35
 */
public interface UserProblemService extends IService<UserProblem> {

    /**
     * 根据用户ID和题目ID查找UserProblem记录
     *
     * @param userId    用户id
     * @param problemId 题目id
     * @return Integer
     */
    Integer find(Integer userId, Integer problemId);

    /**
     * 根据用户ID、题目ID和是否通过查找UserProblem记录
     *
     * @param userId    用户ID
     * @param problemId 题目ID
     * @param passed    是否通过
     * @return Integer
     */
    Integer find(Integer userId, Integer problemId, Boolean passed);

    /**
     * 根据用户ID和passed统计用户通过题目数量
     *
     */
    Integer countPassed(Integer userId, Boolean passed);

    /**
     * 根据用户ID统计用户提交题目数量
     */
    Integer countSubmit(Integer userId);

    /**
     * 根据用户ID和题目集合统计通过数量
     *
     * @return
     */
    Integer countCategoryPassed(Integer userId, Integer categoryId);

    /**
     * 根据用户ID和题目集合统计提交数量
     */
    Integer countCategorySubmit(Integer userId, Integer categoryId);

    /**
     * 通过用户ID、题目集ID、通过状态查找题目ID集合
     *
     * @param userId            用户ID
     * @param problemCategoryId 题目集ID
     * @param passed            是否通过
     * @return List<Integer> 题目ID集合
     */
    List<Integer> findByUserIdAndProblemCategoryIdAndPassed(Integer userId, Integer problemCategoryId, Boolean passed);

    /**
     * 根据题目集ID获取rank榜单
     * @param userProblemDto
     * @param page
     * @return
     */
    IPage<UserProblemDto> getAll(UserProblemDto userProblemDto, Page page);

    /**
     * 获取全部题目的排行榜
     */
    IPage<UserProblemDto> getRank(UserProblemDto userProblemDto, Page page);
}
