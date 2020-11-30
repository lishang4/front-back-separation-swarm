<template>
<el-form :inline="true" :model="formInline" size="small" >
  <el-form-item label="用户信息">
    <el-input class="input" v-model="formInline.account" placeholder="帳號"></el-input>
    <el-input class="input" v-model="formInline.password" placeholder="密碼"></el-input>
    <el-input class="input" v-model="formInline.email" placeholder="email"></el-input>
  </el-form-item>
 <el-form-item>
    <el-button type="primary" @click="onSubmitGet">查詢所有會員資料(get)</el-button>
    <el-button type="primary" @click="onSubmitLoginPost">登入(post)</el-button>
    <el-button type="primary" @click="onSubmitSignUpPost">註冊(post)</el-button>
  </el-form-item>
 <el-input type="textarea" :rows="6" placeholder="此處返回結果" v-model="results" class="textarea"> </el-input>
</el-form>


</template>
<script>
  import axios from 'axios'
  export default {
    data() {
      return {
        formInline: {
          account: '',
          password: '',
          email: '',
        },
        results:''
      }
    },
    methods: {
      onSubmitGet() {
        const config = {
          headers: {
            'Access-Control-Allow-Origin': '*',
          }
        }
        console.log('submit! get');
          axios.get('http://192.168.3.105:55888/api/v1/member_list', config).then(res => {//get()中的参数要与mock.js文件中的Mock.mock()配置的路由保持一致
          this.results = JSON.stringify(res.data);
          console.log(res.data);//在console中看到数据
        }).catch(res => {
          alert('wrong');
        })


      },
      onSubmitLoginPost() {
        const config = {
          headers: {
            'Access-Control-Allow-Origin': '*',
          }
        }
        console.log('submit! get');
          axios.get('http://192.168.3.105:55888/api/v1/'+this.formInline['account'],this.formInline, config).then(res => {//get()中的参数要与mock.js文件中的Mock.mock()配置的路由保持一致
          if(res.data['password'] != this.formInline['password']){
            alert('帳號或密碼錯誤1')
          }
          else {
            this.results = JSON.stringify(res.data);
            console.log(res.data);//在console中看到数据
            alert('登入成功');
          }
        }).catch(res => {
          alert('帳號或密碼錯誤');
        })


      },
      onSubmitSignUpPost() {
        const config = {
          headers: {
            'Access-Control-Allow-Origin': '*',
          }
        }
        console.log('submit! post');
          axios.post('http://192.168.3.105:55888/api/v1/add_member',this.formInline, config).then(res => {//get()中的参数要与mock.js文件中的Mock.mock()配置的路由保持一致
          this.results = JSON.stringify(res.data);
          console.log(res.data);//在console中看到数据
          alert('註冊成功');
        }).catch(res => {
          alert('post error');
        })

      }
    }
  }
</script>

<style scoped>
.input {
  width: 200px
}
button {
  width: 100px
}
.textarea {
  width: 900px
}
</style>
