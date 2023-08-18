#include <iostream>
#include <vector>
#include <algorithm>
#include <queue>
#include <limits.h>
#include <string>
#include <stack>
#include <list>
#include <unordered_set>
#include <sstream>
#include <deque>
#include <math.h>
using namespace std;

int T, N , M;
queue<pair<int,int>> q;
int maximum;

void Solution() {
    int answer = 0;
    while(!q.empty()){
        int word = q.front().first;
        int t = q.front().second;
        q.pop();
        int s = q.size();
        bool possible = true;
        for(int i = 0 ; i<s; i++){
            int temp1 = q.front().first;
            int temp = q.front().second;
            q.pop();
            if(temp > t){
                possible = false;
            }
            q.push({temp1,temp});
        }
        if(possible){
            answer++;
            if(M == word){
                cout << answer << '\n';
                break;
            }
        }
        else{
            q.push({word,t});
        }
    }
}

void Input() {
    cin >> T;
    for(int i = 0 ; i<T; i++){
        maximum = 0;
        while(!q.empty()){
            q.pop();
        }
        cin >> N >> M;
        for(int j = 0 ; j<N; j++){
            int t;
            cin >> t;
            maximum = max(t, maximum);
            q.push({j,t});
        }
        Solution();
    }
}

int main() {
    ios::sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL);
    
    
    Input();
}
