#/usr/bin/env python
# -*- coding: utf-8 -*-
from api import *
LOG = logging.getLogger(__name__)

db_data = fake_db_data.db_data

def setup_route(api):

    # 查詢所有會員 : GET
    api.add_resource(Users, '/api/v1/member_list')

    # 查詢 : GET , 刪除 : DELETE , 修改 : PUT
    api.add_resource(User, '/api/v1/<account>')

    # 新增會員 : POST
    api.add_resource(PostUser, '/api/v1/add_member')

class Users(Resource):
    def get(self):
        if 'member_list' not in db_data:
            return Response(json.dumps({'status':'404','message': 'Not Found'}), status=404)
        return Response(json.dumps(db_data['member_list']), status=200)


class User(Resource):
    def get(self, account):

        # 確認value是否存在key值中
        for customer_data in db_data['member_list']:
            if customer_data['account'] == account:
                return Response(json.dumps(customer_data), status=200)

        # 找不到key值或value不正確
        return Response(json.dumps({'status':'401','message': 'key_error'}), status=401)

    def delete(self, db_name, account):
        pass

    def put(self, db_name, account):
        pass

class PostUser(Resource):
    def post(self):
        '''
        required_args = ['account', 'password', 'email']
        '''
        json_from_request = jsonLoads(request.stream)
        required_args = ['account', 'password', 'email']

        # Bad Request when payload difference.
        for args_ in required_args:
            if args_ not in json_from_request:
                return Response(json.dumps({'status':'400','message': 'Bad Request: '+args_}), status=400)

        # Invalid data when anydata is empty.
        for value in json_from_request:
            if not json_from_request[value]:
                return Response(json.dumps({'status':'400','message': 'invalid data'}), status=400)
        
        # Account already exist in db.
        for data in db_data['member_list']:
            if json_from_request[value] == data['account']:
                return Response(json.dumps({'status':'400','message': 'existed account'}), status=400)

        # Sign-up success !
        db_data['member_list'].append(json_from_request)
        return Response(json.dumps({'status':'201','message': 'Created'}), status=201)