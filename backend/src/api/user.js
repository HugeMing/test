import httpRequest from '@/utils/request'
import { baseApiUrlConfig } from '@/url-config'

export function getUserCount() {
  return httpRequest({
    url: baseApiUrlConfig.userCount,
    method: 'get'
  })
}

export function getUserList(pageNum, pageSize, orderByStudentNo, searchType, keyword) {
  const params = {
    pageNum: pageNum,
    pageSize: pageSize,
    orderByStudentNo: orderByStudentNo
  }
  if (searchType && keyword) {
    params[searchType] = keyword
  }
  return httpRequest({
    url: `${baseApiUrlConfig.userBase}/`,
    method: 'get',
    params: params
  })
}

export function createUser(username, password, email, studentNo) {
  return httpRequest({
    url: `${baseApiUrlConfig.userBase}/`,
    method: 'post',
    data: {
      username: username,
      password: password,
      email: email,
      studentNo: studentNo
    }
  })
}

export function importUser(username, password, email, studentNo, className) {
  return httpRequest({
    url: `${baseApiUrlConfig.importUser}/`,
    method: 'post',
    data: {
      username: username,
      password: password,
      email: email,
      studentNo: studentNo,
      className: className
    }
  })
}

export function updateUser(userId, username, password, email, studentNo, isAdmin) {
  const user = {
    username: username,
    email: email,
    studentNo: studentNo,
    isAdmin: isAdmin
  }
  if (password) {
    user.password = password
  }
  return httpRequest({
    url: `${baseApiUrlConfig.userBase}/${userId}`,
    method: 'put',
    data: user
  })
}

export function getUserDetail(userId) {
  return httpRequest({
    url: `${baseApiUrlConfig.userBase}/${userId}`,
    method: 'get'
  })
}

export function deleteUser(userId) {
  return httpRequest({
    url: `${baseApiUrlConfig.userBase}/${userId}`,
    method: 'delete'
  })
}
