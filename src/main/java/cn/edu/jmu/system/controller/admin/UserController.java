package cn.edu.jmu.system.controller.admin;

import cn.edu.jmu.common.response.BasicResponse;
import cn.edu.jmu.common.util.EncryptUtil;
import cn.edu.jmu.common.util.ResponseUtil;
import cn.edu.jmu.common.util.ValidateUtil;
import cn.edu.jmu.system.entity.User;
import cn.edu.jmu.system.entity.UserGroup;
import cn.edu.jmu.system.entity.UserGroupCollection;
import cn.edu.jmu.system.entity.dto.UserDto;
import cn.edu.jmu.system.service.UserGroupCollectionService;
import cn.edu.jmu.system.service.UserGroupService;
import cn.edu.jmu.system.service.UserService;
import cn.edu.jmu.system.service.converter.UserConverter;
import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.ObjectUtils;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * @author sgh
 * @date 2019/6/18 19:17
 */
@RestController
@RequiresRoles(value = {"admin", "teacher"}, logical = Logical.OR)
@RequestMapping("/api/admin/users")
public class UserController {

    @Resource
    private UserService userService;
    @Resource
    private UserGroupService userGroupService;
    @Resource
    private UserGroupCollectionService userGroupCollectionService;

    /**
     * 查询所有用户
     */
    @GetMapping(value = "/")
    public ResponseEntity<BasicResponse> getAll(UserDto userDto, @RequestParam(defaultValue = "") String orderByStudentNo, @RequestParam(defaultValue = "1") Integer pageNum, @RequestParam(defaultValue = "10") Integer pageSize) {
        Page<User> page = new Page<>(pageNum, pageSize);
        IPage<UserDto> iPage;
        if ("asc".equals(orderByStudentNo)) {
            iPage = userService.getAll(userDto, page, User::getStudentNo, false);
        } else if ("desc".equals(orderByStudentNo)) {
            iPage = userService.getAll(userDto, page, User::getStudentNo, true);
        } else {
            iPage = userService.getAll(userDto, page, User::getId, true);
        }
        return ResponseUtil.buildResponse("查询成功", iPage);
    }

    /**
     * 通过ID查询用户详情
     */
    @GetMapping(value = "/{id}")
    public ResponseEntity<BasicResponse> selectUserById(@PathVariable("id") Integer id) {
        User user = userService.getById(id);
        UserDto userDto = UserConverter.toDto(user);
        return ResponseUtil.buildResponse("查询成功", userDto);
    }

    /**
     * 更新用户
     */
    @PutMapping(value = "/{userId}")
    public ResponseEntity<BasicResponse> update(@PathVariable("userId") Integer userId, @RequestBody @Validated UserDto userDto) {
        System.out.println(userDto);
        if (userService.existById(userId)) {
            userDto.setId(userId);
            return ResponseUtil.buildResponse(userService.update(userDto), "更新用户信息成功", "更新用户信息失败");
        } else {
            return ResponseUtil.fail("用户ID不存在");
        }
    }

    /**
     * 更新用户状态
     */
    @PutMapping(value = "/status/{id}")
    public ResponseEntity<BasicResponse> status(@PathVariable("id") Integer id) {
        boolean success = userService.changeUserStatus(id);
        return ResponseUtil.buildResponse(success, "更改成功", "更改失败");
    }

    /**
     * 添加用户
     */
    @PostMapping(value = "/")
    public ResponseEntity<BasicResponse> insert(@RequestBody @Validated UserDto userDto) {
        System.out.println(userDto);
        if (!ValidateUtil.isEmail(userDto.getEmail())) {
            return ResponseUtil.fail("请检查邮箱地址是否正确！");
        }
        User byId = userService.getOne(Wrappers.<User>lambdaQuery().eq(User::getUsername, userDto.getUsername()));
        if (ObjectUtil.isNotNull(byId)) {
            return ResponseUtil.fail("该用户名已存在");
        }
        if (ObjectUtils.isEmpty(userDto.getPassword())) {
            return ResponseUtil.fail("密码不能为空");
        }
        User byEmail = userService.getOne(Wrappers.<User>lambdaQuery().eq(User::getEmail, userDto.getEmail()));
        if (ObjectUtil.isNotNull(byEmail)) {
            return ResponseUtil.fail("该邮箱已存在");
        }
        User byStudentNo = userService.getOne(Wrappers.<User>lambdaQuery().eq(User::getStudentNo, userDto.getStudentNo()));
        if (ObjectUtil.isNotNull(byStudentNo)) {
            return ResponseUtil.fail("该学号已存在");
        }
        User user = UserConverter.toEntity(userDto);
        String salt = EncryptUtil.generatorSalt();
        user.setSalt(salt);
        user.setPassword(EncryptUtil.encryption(user.getUsername(), user.getPassword(), salt));
        boolean success = userService.saveOrUpdate(user);
        if(success){
            return ResponseUtil.buildResponse("新增用户成功", user);
        }
        return ResponseUtil.buildResponse(success, "新增用户成功", "新增用户失败");
    }

    /**
     * 导入用户
     */
    @PostMapping(value = "/importUser")
    public ResponseEntity<BasicResponse> addExcel(@RequestBody @Validated UserDto userDto) {
        if (!ValidateUtil.isEmail(userDto.getEmail())) {
            return ResponseUtil.fail("请检查邮箱地址是否正确！");
        }
        User byId = userService.getOne(Wrappers.<User>lambdaQuery().eq(User::getUsername, userDto.getUsername()));
        if (ObjectUtil.isNotNull(byId)) {
            return ResponseUtil.fail("该用户名已存在");
        }
        if (ObjectUtils.isEmpty(userDto.getPassword())) {
            return ResponseUtil.fail("密码不能为空");
        }
        User byEmail = userService.getOne(Wrappers.<User>lambdaQuery().eq(User::getEmail, userDto.getEmail()));
        if (ObjectUtil.isNotNull(byEmail)) {
            return ResponseUtil.fail("该邮箱已存在");
        }
        User byStudentNo = userService.getOne(Wrappers.<User>lambdaQuery().eq(User::getStudentNo, userDto.getStudentNo()));
        if (ObjectUtil.isNotNull(byStudentNo)) {
            return ResponseUtil.fail("该学号已存在");
        }
        //查找是否存在className班级
        System.out.println(111);
        //UserGroup userGroup = userGroupService.getOne(Wrappers.<UserGroup>lambdaQuery().eq(UserGroup::getName, userDto.getClassName()));
        System.out.println("000" + userGroupService.getByName(userDto.getClassName()));
        if(ObjectUtil.isNull(userGroupService.getByName(userDto.getClassName()))){
            userGroupService.createByName(userDto.getClassName());
        }
        //查找到班级对应的ID
        int classId = userGroupService.getByName(userDto.getClassName());

        //插入用户
        User user = UserConverter.toEntity(userDto);
        String salt = EncryptUtil.generatorSalt();
        user.setSalt(salt);
        user.setPassword(EncryptUtil.encryption(user.getUsername(), user.getPassword(), salt));
        boolean success = userService.saveOrUpdate(user);

        System.out.println(222);
        //把学生添加到sys_group_collections表中
        UserGroupCollection userGroupCollection = new UserGroupCollection();
        userGroupCollection.setUserGroupId(classId);
        User byStudentNo2 = userService.getOne(Wrappers.<User>lambdaQuery().eq(User::getStudentNo, userDto.getStudentNo()));
        userGroupCollection.setUserId(byStudentNo2.getId());
        userGroupCollectionService.save(userGroupCollection);
        System.out.println(333);
//        if(success){
//            return ResponseUtil.buildResponse("新增用户成功", user);
//        }
        if(success) System.out.println("success");
        return ResponseUtil.buildResponse(success, user.getStudentNo(), "false");
    }


    /**
     * 获取用户数量
     */
    @GetMapping(value = "/count")
    public ResponseEntity<BasicResponse> count() {
        int count = userService.count();
        return ResponseUtil.buildResponse(count);
    }
}
