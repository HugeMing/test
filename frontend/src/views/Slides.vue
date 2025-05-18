<template>
  <div id="container" class="resizable">
    <iframe id="frame" ref="frame" :src="addr" class="frameClass" frameborder="0"></iframe>
  </div>
</template>
<script>
import $ from 'jquery'
export default {
  name: '',
  components: {},
  data () {
    return {
      addr: ''
    }
  },
  mounted () {
    let url = this.$route.params.slidesURL;
    this.addr = '/static/slides/' + url + '/index.html';
    this.init()
  },
  methods: {
    init () {
      // 根据当前窗口大小设定 container 的高度
      var container = $('#container.resizable')
      container.css({ 'height': $(window).height(), 'width': '100%', 'opacity': 1 })
      // iframe大小
      var frame = $('#frame.frameClass')
      frame.css({ 'height': $(window).height(), 'width': '100%', 'opacity': 1 })
    }
  }
}
</script>
<style lang="scss" scoped>
.resizable {
  margin-top: 0px;
  margin-bottom: 0px;
}
</style>