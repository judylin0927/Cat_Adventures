#!/usr/bin/env bash

# ---------------------------
#  遊戲標題與製作團隊
# ---------------------------
story_title="《勇者貓的地下城冒險：三條血量版》"
team_info="製作團隊:\nJudy : 發想者 與 主製作\n\nAllen、Andrew、Wayne : 遊戲製作\n\nTony : UI介面設計"

# ---------------------------
#  三條血量（待職業選完再設定）
# ---------------------------
courage=0
wisdom=0
agility=0

# ---------------------------
#  永恆貓鈴碎片
#  及其是否已撿取(0=未撿, 1=已撿)
# ---------------------------
eternal_bell_fragments=0
frag1_collected=0
frag2_collected=0
frag3_collected=0

# ---------------------------
#  函式：顯示當前三條血量 + 碎片
# ---------------------------
show_stats() {
    dialog --title "當前狀態" \
           --msgbox "勇氣: $courage\n智慧: $wisdom\n靈巧: $agility\n\n永恆貓鈴碎片收集: $eternal_bell_fragments / 3" \
           12 50
}

# ---------------------------
#  函式：檢查若血量 <= 0，遊戲結束
# ---------------------------
check_game_over() {
    if [[ $courage -le 0 || $wisdom -le 0 || $agility -le 0 ]]; then
        dialog --title "遊戲結束" \
               --msgbox "您的勇者貓失去了關鍵能力...\n\n王國因此淪陷，您也被永遠囚禁於地下城。\n\n遊戲結束。" \
               10 50
        clear
        exit 1
    fi
}

# ---------------------------
# [第二章]：三個故事海龜湯 版本
# ---------------------------

chapter2_mini_stories() {

    # 先提示玩家：必須解出三個故事中的"至少一個" (或您可以自行調整規則)
    dialog --msgbox "$catname 來到了地下城入口。\n\n這裡有三個傳說故事等著你解開謎團...\n必須成功完成其中一個故事，才能進入下一層！" 12 60

    # ★將您提供的3故事程式碼放這裡★
    # -----------------------------------------------------------
    declare -A stories=(
        [1]="有個人搭乘火車前往外縣市治療眼疾，看完醫生後眼疾痊癒，重見光明。然而，在回程的火車上，當火車經過一個隧道時，這個人突然跳車自殺了。請問他為什麼會這麼做？"
        [2]="有一對母女三人，母親去世了，姐妹兩人前往參加母親的葬禮。\n在葬禮上，妹妹遇見了一位男生，對他一見鍾情。\n然而，葬禮結束後，那位男生消失無蹤，妹妹怎麼找也找不到他。\n一個月後，妹妹竟然殺害了自己的姐姐，原因何在？"
        [3]="有個男人開車去機場趕班機，在到了一個三岔口時，看見一個男孩蹲在地上哭泣。\n男人下車詢問男孩為什麼哭，男孩說他迷路了。\n於是男人帶著小男孩朝他描述的大致方向找去，在開了很久的車之後，男孩說看見了自己的家，便跳下車。\n這時男人發現自己已經誤了班機的起飛時間。\n男人在車裡沮喪起來，突然又嚇的直冒汗，然後又欣慰的笑了。\n是什麼事造成男人這樣的情感變化？"
    )
    declare -A answers=(
        [1]="又失明了"
        [2]="再辦一次喪禮"
        [3]="靈魂"
    )

    # 6 道線索 (clues) + 4 選項 (options) + 正確答案 (correct_options)
    declare -A clues options correct_options

    # story 1:
    clues[1,1]="這個人為什麼要去外縣市？"
    options[1,1]="1 '去探親' 2 '出差' 3 '治療眼睛' 4 '旅遊'"
    correct_options[1,1]=3

    clues[1,2]="他去治療的眼疾是什麼？"
    options[1,2]="1 '近視' 2 '白內障' 3 '失明' 4 '紅眼病'"
    correct_options[1,2]=3

    clues[1,3]="治療結果如何？"
    options[1,3]="1 '失敗' 2 '沒改善' 3 '成功恢復' 4 '部分改善'"
    correct_options[1,3]=3

    clues[1,4]="他搭乘什麼交通工具回家？"
    options[1,4]="1 '計程車' 2 '火車' 3 '高鐵' 4 '巴士'"
    correct_options[1,4]=2

    clues[1,5]="在火車上發生了什麼事？"
    options[1,5]="1 '遇仇家' 2 '突然天黑' 3 '聽到怪聲' 4 '被推下車'"
    correct_options[1,5]=2

    clues[1,6]="為什麼突然天黑？"
    options[1,6]="1 '火車進隧道' 2 '日蝕' 3 '再度失明' 4 '晚上了'"
    correct_options[1,6]=1

    # story 2:
    clues[2,1]="這個妹妹在哪裡遇到男生？"
    options[2,1]="1 '婚禮' 2 '母親葬禮' 3 '派對' 4 '學校'"
    correct_options[2,1]=2

    clues[2,2]="妹妹對這男生有什麼感覺？"
    options[2,2]="1 '害怕' 2 '一見鍾情' 3 '憎惡' 4 '普通'"
    correct_options[2,2]=2

    clues[2,3]="男生葬禮後去哪？"
    options[2,3]="1 '失蹤' 2 '回家' 3 '牽手' 4 '交換聯絡'"
    correct_options[2,3]=1

    clues[2,4]="妹妹為何找不到男生？"
    options[2,4]="1 '沒留下聯絡' 2 '男生有女友' 3 '失憶' 4 '被姐姐搶走'"
    correct_options[2,4]=1

    clues[2,5]="她為何殺了姐姐？"
    options[2,5]="1 '仇恨' 2 '情緒崩潰' 3 '想再辦葬禮' 4 '爭遺產'"
    correct_options[2,5]=3

    clues[2,6]="為何想辦葬禮？"
    options[2,6]="1 '想再見男生' 2 '祭拜母親' 3 '詐領保險' 4 '為姐姐報仇'"
    correct_options[2,6]=1

    # story 3:
    clues[3,1]="男人為什麼去機場？"
    options[3,1]="1 '送人' 2 '趕班機' 3 '接機' 4 '旅遊'"
    correct_options[3,1]=2

    clues[3,2]="男孩為何在路邊哭？"
    options[3,2]="1 '迷路了' 2 '父母吵架' 3 '被拐' 4 '尋短'"
    correct_options[3,2]=1

    clues[3,3]="男人為何載他回家？"
    options[3,3]="1 '出於善意' 2 '被威脅' 3 '好奇' 4 '想去警局'"
    correct_options[3,3]=1

    clues[3,4]="男人錯過班機後聽到什麼？"
    options[3,4]="1 '飛機延誤' 2 '飛機失事' 3 '天氣惡劣' 4 '家人來電'"
    correct_options[3,4]=2

    clues[3,5]="為何他冒冷汗？"
    options[3,5]="1 '飛機墜毀' 2 '太熱' 3 '小男孩威脅' 4 '想起什麼事'"
    correct_options[3,5]=1

    clues[3,6]="他為何最後笑了？"
    options[3,6]="1 '小男孩是靈魂救了他' 2 '飛機安全降落' 3 '撿到錢包' 4 '家人抵達'"
    correct_options[3,6]=1

    # 紀錄已完成的故事
    declare -A completed_stories
    selected_story=0

    # 隨機選故事
    function choose_story() {
        local story_arr=()
        for id in 1 2 3; do
            if [ -z "${completed_stories[$id]}" ]; then
                story_arr+=("$id")
            fi
        done

        if [ ${#story_arr[@]} -eq 0 ]; then
            # 全都完成了 => break
            return 1
        fi

        local r=$((RANDOM % ${#story_arr[@]}))
        selected_story="${story_arr[$r]}"
        # 顯示故事簡介
        dialog --msgbox "${stories[$selected_story]}" 12 60
        return 0
    }

    # 選擇線索
    function choose_clue() {
        local story_id="$1"
        local collected=0
        local used_clues=()

        while [ $collected -lt 6 ]; do
            local av_clues=()
            for i in {1..6}; do
                if [[ ! " ${used_clues[@]} " =~ " $i " ]]; then
                    av_clues+=("$i" "${clues[$story_id,$i]}")
                fi
            done

            dialog --menu "請選擇要問的線索：" 15 60 ${#av_clues[@]} "${av_clues[@]}" 2>clue_choice.tmp
            local clueid=$(<clue_choice.tmp)
            rm -f clue_choice.tmp
            [ -z "$clueid" ] && continue  # 若玩家取消

            # 顯示此線索的 4 個選項
            dialog --menu "${clues[$story_id,$clueid]}" 15 50 4 ${options[$story_id,$clueid]} 2>choice.tmp
            local ans=$(<choice.tmp)
            rm -f choice.tmp

            if [ "$ans" == "${correct_options[$story_id,$clueid]}" ]; then
                dialog --msgbox "正確！" 6 40
                used_clues+=("$clueid")
                ((collected++))
            else
                dialog --msgbox "錯誤！請重新選擇。" 6 40
            fi
        done
    }

    # 最後填空
    function ask_final() {
        local txt=""
        case $selected_story in
            1) txt="當火車進入隧道一片漆黑，他以為自己____，感到絕望而跳車。（四個字）" ;;
            2) txt="妹妹為了再見男生，決定殺死姊姊以便________。（六個字）" ;;
            3) txt="男孩其實是____，男人因而錯過班機卻保住性命。（兩個字）" ;;
        esac

        dialog --inputbox "$txt" 10 50 2>ans.tmp
        local user_ans=$(<ans.tmp)
        rm -f ans.tmp

        if [ "$user_ans" == "${answers[$selected_story]}" ]; then
            dialog --msgbox "解謎成功！你完成了此故事的所有線索及答案。" 8 50
            completed_stories[$selected_story]=1
        else
            dialog --msgbox "錯誤！請換個故事看看..." 8 50
        fi
    }

    # 核心流程 => 只要完成「1 個故事」即可(或者您要玩家3個都做完，也行)
    while true; do
        # 選故事
        if ! choose_story; then
            # 全部故事都已完成 => 直接跳出
            break
        fi
        # 選線索
        choose_clue "$selected_story"
        # 填空
        ask_final
        # 若填空正確 => break
        if [ -n "${completed_stories[$selected_story]}" ]; then
            # +1 智慧
            wisdom=$((wisdom+1))
            dialog --msgbox "恭喜！你已解開這個故事的謎團。(智慧+1)\n你已能通過此處試煉。" 8 50
            break
        fi
    done

    check_game_over
    show_stats
}

# ===============================
# 第四章：數獨（新版程式）
# ===============================
chapter4_sudoku() {
    dialog --msgbox "接著，$catname 來到了地下第二層-數獨迷宮。\n請試圖解開吧!勇者貓!。" 10 50

    # (1) 三組題目 + 解答
    declare -a NS_SUDOKU1=(
      5 3 4 0 7 0 9 1 2
      6 7 0 1 9 5 3 0 8
      1 0 8 3 4 2 5 6 7
      8 5 9 0 6 1 4 2 3
      4 2 0 8 5 3 0 9 1
      7 1 3 9 2 0 8 5 6
      9 6 1 5 3 7 2 8 4
      2 8 7 4 1 9 6 3 5
      3 4 5 0 8 6 1 7 9
    )
    declare -a NS_SUDOKU1_SOL=(
      5 3 4 6 7 8 9 1 2
      6 7 2 1 9 5 3 4 8
      1 9 8 3 4 2 5 6 7
      8 5 9 7 6 1 4 2 3
      4 2 6 8 5 3 7 9 1
      7 1 3 9 2 4 8 5 6
      9 6 1 5 3 7 2 8 4
      2 8 7 4 1 9 6 3 5
      3 4 5 2 8 6 1 7 9
    )

    declare -a NS_SUDOKU2=(
      0 2 3 4 5 6 7 8 9
      4 5 6 7 8 9 1 0 3
      7 8 9 1 2 3 4 5 6
      2 1 4 3 6 5 8 9 7
      3 6 5 8 9 7 2 1 4
      8 9 7 2 1 4 3 6 5
      5 3 1 6 4 2 9 7 8
      6 4 2 9 7 8 5 3 1
      9 7 8 5 3 1 6 4 2
    )
    declare -a NS_SUDOKU2_SOL=(
      1 2 3 4 5 6 7 8 9
      4 5 6 7 8 9 1 2 3
      7 8 9 1 2 3 4 5 6
      2 1 4 3 6 5 8 9 7
      3 6 5 8 9 7 2 1 4
      8 9 7 2 1 4 3 6 5
      5 3 1 6 4 2 9 7 8
      6 4 2 9 7 8 5 3 1
      9 7 8 5 3 1 6 4 2
    )

    declare -a NS_SUDOKU3=(
      0 9 2 1 5 4 3 8 6
      6 4 3 8 2 7 1 5 9
      8 5 1 3 9 6 7 2 4
      2 6 5 9 7 3 8 4 1
      4 8 9 5 6 1 2 7 3
      3 1 7 4 8 2 9 6 5
      1 3 6 7 4 8 5 9 2
      9 7 4 2 1 5 6 3 8
      5 2 8 6 3 9 4 1 7
    )
    declare -a NS_SUDOKU3_SOL=(
      7 9 2 1 5 4 3 8 6
      6 4 3 8 2 7 1 5 9
      8 5 1 3 9 6 7 2 4
      2 6 5 9 7 3 8 4 1
      4 8 9 5 6 1 2 7 3
      3 1 7 4 8 2 9 6 5
      1 3 6 7 4 8 5 9 2
      9 7 4 2 1 5 6 3 8
      5 2 8 6 3 9 4 1 7
    )

    # 全域變數
    declare -a n_current_board
    declare -a n_original_board
    declare -a n_solution
    local n_cursor_row=0
    local n_cursor_col=0

    # 1) choose_puzzle
    n_choose_puzzle() {
      local r=$((RANDOM % 3 + 1))
      case $r in
        1)
          n_current_board=("${NS_SUDOKU1[@]}")
          n_original_board=("${NS_SUDOKU1[@]}")
          n_solution=("${NS_SUDOKU1_SOL[@]}")
          ;;
        2)
          n_current_board=("${NS_SUDOKU2[@]}")
          n_original_board=("${NS_SUDOKU2[@]}")
          n_solution=("${NS_SUDOKU2_SOL[@]}")
          ;;
        3)
          n_current_board=("${NS_SUDOKU3[@]}")
          n_original_board=("${NS_SUDOKU3[@]}")
          n_solution=("${NS_SUDOKU3_SOL[@]}")
          ;;
      esac
    }

    # 2) build_sudoku_view
    n_build_sudoku_view() {
      local output=""
      for ((i=0;i<9;i++)); do
        for ((j=0;j<9;j++)); do
          local idx=$((i*9+j))
          local val="${n_current_board[$idx]}"
          if [[ $i -eq $n_cursor_row && $j -eq $n_cursor_col ]]; then
            # 游標
            if [[ "$val" -eq 0 ]]; then
              output+="[.] "
            else
              output+="[$val] "
            fi
          else
            if [[ "$val" -eq 0 ]]; then
              output+=" .  "
            else
              output+=" $val  "
            fi
          fi
          if (( (j+1)%3 == 0 && j<8 )); then
            output+="|"
          fi
        done
        output+="\n"
        if (( (i+1)%3 == 0 && i<8 )); then
          output+="------------------------------\n"
        fi
      done
      echo "$output"
    }

    # 3) is_game_complete
    n_is_game_complete() {
      for cell in "${n_current_board[@]}"; do
        if [[ "$cell" -eq 0 ]]; then
          return 1
        fi
      done
      return 0
    }

    # 4) is_game_correct
    n_is_game_correct() {
      for ((idx=0; idx<81; idx++)); do
        if [[ "${n_current_board[$idx]}" -ne "${n_solution[$idx]}" ]]; then
          return 1
        fi
      done
      return 0
    }

    # fill_number
    n_fill_number() {
      local idx=$((n_cursor_row*9 + n_cursor_col))
      if [[ "${n_original_board[$idx]}" -ne 0 ]]; then
        dialog --msgbox "此位置是題目原數字，不能修改" 6 36
        return
      fi
      dialog --inputbox "請輸入1~9：" 8 30 2>num.tmp
      local num; num=$(<num.tmp); rm -f num.tmp
      if [[ "$num" =~ ^[1-9]$ ]]; then
        n_current_board[$idx]=$num
      else
        dialog --msgbox "輸入不合法(請輸入1~9)" 6 36
      fi
    }

    # clear_number
    n_clear_number() {
      local idx=$((n_cursor_row*9 + n_cursor_col))
      if [[ "${n_original_board[$idx]}" -ne 0 ]]; then
        dialog --msgbox "此位置是原始數字，不能清除" 6 36
        return
      fi
      n_current_board[$idx]=0
    }

    # game_loop
    n_game_loop() {
      local b_str; b_str=$(n_build_sudoku_view)
      dialog --no-cancel --title "數獨遊戲" \
        --menu "$b_str\n\n請選擇操作：" 28 85 10 \
        "UP"    "上移" \
        "DOWN"  "下移" \
        "LEFT"  "左移" \
        "RIGHT" "右移" \
        "ENTER" "輸入數字" \
        "SPACE" "清除該格" \
        "CHECK" "檢查是否正確" \
        "Q"     "退出/放棄" 2>menu_choice.tmp

      local choice; choice=$(<menu_choice.tmp); rm -f menu_choice.tmp

      case "$choice" in
        UP)
          if [[ $n_cursor_row -gt 0 ]]; then ((n_cursor_row--)); fi
          ;;
        DOWN)
          if [[ $n_cursor_row -lt 8 ]]; then ((n_cursor_row++)); fi
          ;;
        LEFT)
          if [[ $n_cursor_col -gt 0 ]]; then ((n_cursor_col--)); fi
          ;;
        RIGHT)
          if [[ $n_cursor_col -lt 8 ]]; then ((n_cursor_col++)); fi
          ;;
        ENTER)
          n_fill_number
          ;;
        SPACE)
          n_clear_number
          ;;
        CHECK)
          if n_is_game_complete; then
            if n_is_game_correct; then
              dialog --title "檢查結果" --msgbox "恭喜！全部填寫正確！" 7 30
            else
              dialog --title "檢查結果" --msgbox "有些數字填錯了，請繼續修改。" 7 35
            fi
          else
            dialog --title "檢查結果" --msgbox "還有空格未填寫。" 7 30
          fi
          ;;
        Q)
          dialog --yesno "確定要放棄嗎？" 7 30
          if [[ $? -eq 0 ]]; then
            # 結束 => 視為失敗
            return 1
          fi
          ;;
      esac
      return 0
    }

    # 開始
    n_choose_puzzle
    n_cursor_row=0
    n_cursor_col=0

    while true; do
      while true; do
        n_game_loop
        local st=$?
        if [[ $st -eq 1 ]]; then
          # 玩家放棄 => 視為失敗 => 回傳
          agility=$((agility - 1))
          check_game_over
          dialog --msgbox "迷宮開始崩塌，$catname 勉強逃離(靈巧-1)。\n回神後發現仍被傳回此區，必須重新挑戰才能前往下一層！" 10 50
          show_stats
          # 重新初始化 => 再玩
          n_choose_puzzle
          n_cursor_row=0
          n_cursor_col=0
        else
          # 檢查是否完成
          if n_is_game_complete; then
            # 填滿 => 是否正確
            if n_is_game_correct; then
              # 成功
              break
            else
              dialog --msgbox "你雖然填滿，但答案錯誤，請繼續修正。" 7 45
            fi
          fi
        fi
      done
      # 成功完成 => 離開外層
      break
    done

    # 數獨完成 => +1 智慧
    wisdom=$((wisdom + 1))
    dialog --msgbox "恭喜解開數獨！(智慧+1)" 7 40
    check_game_over

    # 若還沒拿到第二塊碎片 => 開寶箱
    if [ $frag2_collected -eq 0 ]; then
      dialog --yesno "在迷宮最深處發現一個骷髏鼠頭的寶箱，是否打開？" 8 50
      if [ $? -eq 0 ]; then
        frag2_collected=1
        eternal_bell_fragments=$((eternal_bell_fragments + 1))
        dialog --msgbox "獲得了第二塊『永恆貓鈴碎片』！(目前: $eternal_bell_fragments / 3)" 8 50
      else
        dialog --msgbox "你猶豫了一下，沒有打開寶箱..." 6 40
      fi
    fi

    show_stats
}



# ---------------------------
#  第五章：推理遊戲 (函式)
# ---------------------------
chapter5_riddle() {
    dialog --msgbox "地下第三層\n前方出現一位『守護者貓』。\n\n據傳，守護者貓乃是地下城意志的化身，\n世代棲息於此，考驗歷代勇者貓的智慧與心志。\n牠看似平靜，但眼神中卻蘊藏著無盡的謎團。" 12 60

    while true; do
        answer=$(dialog --stdout --menu "守護者貓對你拋出了一個高難度推理謎題...\n\n在天堂與地獄的分叉路口，\n有兩位守衛：一個必說實話，一個必說謊。\n你只能問一個問題，如何才能確保選對通往天堂的路？\n\n請選擇你認為的正確問題：" \
            20 60 6 \
            "A" "問：「天堂之路怎麼走？」" \
            "B" "問：「地獄之路怎麼走？」" \
            "C" "問：「你是誠實的嗎？」" \
            "D" "問：「如果你是對的，天堂之路在哪？」" \
            "E" "問：「另一位守衛覺得地獄之路在哪？」" \
            "F" "隨機選一條路，碰碰運氣！")

        # 如果玩家選 E，代表答對
        if [ "$answer" == "E" ]; then
            wisdom=$((wisdom + 1))
            dialog --msgbox "守護者貓微微點頭，表示你的推理是正確的。(智慧+1)\n\n牠的身影開始逐漸淡去..." 10 60

            # 若還沒拿到第三塊碎片 => 給玩家一次選擇
            if [ $frag3_collected -eq 0 ]; then
                dialog --yesno "守護者貓消失前，遺留了一個閃閃發亮的碎片。\n要撿起嗎？" 10 60
                if [ $? -eq 0 ]; then
                    frag3_collected=1
                    eternal_bell_fragments=$((eternal_bell_fragments + 1))
                    dialog --msgbox "你撿起了第三塊『永恆貓鈴碎片』！\n(目前: $eternal_bell_fragments / 3)" 8 50
                else
                    dialog --msgbox "你沒有撿取那個碎片，也許那和之前的碎片息息相關..." 8 50
                fi
            fi

            show_stats
            return 0  # 回傳 0 => 成功，結束此函式
        else
            # 代表答錯 => 扣 1 勇氣
            courage=$((courage - 1))
            check_game_over
            dialog --msgbox "答錯了，守護者貓發怒，將你打回上一關...(勇氣-1)\n必須重新面對數獨迷宮。" 10 60
            show_stats
            return 1  # 回傳 1 => 失敗，需要重玩數獨
        fi
    done
}


# ---------------------------
#  [主程式開始]
# ---------------------------

dialog --title "$story_title" --msgbox "$story_title\n----------------------------------------------------\n$team_info" 13 60

# (A) 職業選擇
catvariety=$(dialog --stdout --menu "請選擇您的貓咪品種 (即職業)" 15 40 5 \
    1 "緬因貓 (劍士)" \
    2 "英國短毛貓 (弓箭手)" \
    3 "布偶貓 (法師)" \
    4 "蘇格蘭摺耳貓 (盜賊)" \
    5 "波斯貓 (海盜)")

catname=$(dialog --stdout --inputbox "請為勇者貓取個名字!" 8 40)

case $catvariety in
    1) variety="緬因貓";   class="劍士"
       # 基礎屬性：勇氣2，智慧0，靈巧1
       courage=2; wisdom=0; agility=1 ;;
    2) variety="英國短毛貓"; class="弓箭手"
       # 基礎屬性：勇氣1，智慧0，靈巧2
       courage=1; wisdom=0; agility=2 ;;
    3) variety="布偶貓";   class="法師"
       # 基礎屬性：勇氣0，智慧2，靈巧1
       courage=0; wisdom=2; agility=1 ;;
    4) variety="蘇格蘭摺耳貓"; class="盜賊"
       # 基礎屬性：勇氣1，智慧0，靈巧2
       courage=1; wisdom=0; agility=2 ;;
    5) variety="波斯貓";   class="海盜"
       # 基礎屬性：勇氣1，智慧1，靈巧1
       courage=1; wisdom=1; agility=1 ;;
    *) variety="未知品種"; class="無職業"
       courage=1; wisdom=1; agility=1 ;;
esac

# 顯示說明，告知玩家各項屬性的用途與基礎值
explanation="您的職業『$variety ($class)』具有以下基礎屬性：\n
  勇氣：代表您的戰鬥力與堅韌程度\n
  智慧：代表您解謎與判斷的能力\n
  靈巧：代表您的敏捷度與閃避能力\n
基礎屬性數值為：\n
  勇氣：$courage
  智慧：$wisdom
  靈巧：$agility

\n接下來，您可以額外分配9點屬性點，\n請將點數分配給【勇氣】與【智慧】，
剩餘未分配的點數將自動加給【靈巧】。\n這將影響您在地下城中的表現與最終結局!"

dialog --msgbox "$explanation" 18 70

# ---------------------------
#  屬性點分配 (額外9點)
# ---------------------------
total_points=9

extra_courage=$(dialog --stdout --inputbox "請輸入額外分配給【勇氣】的點數 (總共 $total_points 點):" 8 60)
extra_wisdom=$(dialog --stdout --inputbox "請輸入額外分配給【智慧】的點數:" 8 60)
# 轉換為數字，若無輸入則預設為0
extra_courage=${extra_courage:-0}
extra_wisdom=${extra_wisdom:-0}
used_points=$(( extra_courage + extra_wisdom ))
if [ $used_points -gt $total_points ]; then
    dialog --msgbox "您分配的點數超過 $total_points 點，請重新分配。" 8 40
    exit 1
fi
extra_agility=$(( total_points - used_points ))

# 更新屬性：最終屬性 = 基礎屬性 + 額外分配點數
courage=$(( courage + extra_courage ))
wisdom=$(( wisdom + extra_wisdom ))
agility=$(( agility + extra_agility ))

# ---------------------------
#  顯示最終初始屬性
# ---------------------------
echo "品種：$variety" > catthing.txt
echo "職業：$class" >> catthing.txt
echo "名字：$catname" >> catthing.txt
echo "初始屬性：勇氣=$courage, 智慧=$wisdom, 靈巧=$agility" >> catthing.txt

dialog --title "請確認您的選擇" --textbox catthing.txt 10 50

# (B) 第一章：城門抉擇
dialog --yesno "剛踏出貓咪城門，$catname 便遇到了一隻神祕的無毛貓。\n\n無毛貓先生看似年邁，卻蘊含著古老而深邃的氣息。\n\
據說他曾是上一代的『輔佐者貓』，與先前的勇者並肩作戰。\n\
而今，他肩負著引導新一代勇者的使命。\n\n\
無毛貓先生:「若血條歸零，你的靈魂將永遠困在這座地下城。\n\
你確定要承擔這份重責嗎？」" 18 65

if [ $? -ne 0 ]; then
    dialog --msgbox "您放棄冒險，貓咪王國最終被老鼠國攻陷...\n\n您只能在王國廢墟中流浪。" 8 50
    clear
    exit 0
fi

show_stats

# 第二章 : 定義三個故事
chapter2_mini_stories



# (D) 第三章：地下一層
while true; do
    dialog --yesno "在地下一層，左右兩條路擺在眼前...\n左通道：閃爍著微弱的燈光\n右通道：黑暗如深淵，伸手不見五指\n(Yes=左邊, No=右邊)" 10 50
    if [ $? -eq 0 ]; then
        # 左邊通道
        dialog --yesno "發現一個古老的寶箱，上面印著骷髏貓的臉，要打開嗎？" 8 50
        if [ $? -eq 0 ]; then
            agility=$((agility - 1))
            courage=$((courage + 1))
            dialog --msgbox "打開寶箱，獲得『貓泥犒賞』(勇氣+1)！\n但觸發陷阱(靈巧-1)！" 10 50
            check_game_over
            break
        else
            wisdom=$((wisdom + 1))
            dialog --msgbox "放棄打開寶箱，意外發現後方的通道，獲得智慧果實(智慧+1)！" 10 50
            check_game_over
            break
        fi
    else
        # 右邊通道 -> 戰鬥 or 潛行
        choose_fight=$(dialog --stdout --menu "黑暗通道內有巨型蜘蛛！\n要怎麼做？" 12 60 2 \
            1 "正面戰鬥(消耗勇氣)" \
            2 "潛行避開(消耗靈巧)")
        case $choose_fight in
            1)
                courage=$((courage - 1))
                check_game_over
                agility=$((agility + 1))
                dialog --msgbox "正面擊敗蜘蛛(勇氣-1)，並獲得靈巧羽毛(靈巧+1)！" 10 50
                ;;
            2)
                agility=$((agility - 1))
                check_game_over
                # 若還沒拿到第一塊碎片 => 拿
                if [ $frag1_collected -eq 0 ]; then
                    frag1_collected=1
                    eternal_bell_fragments=$((eternal_bell_fragments + 1))
                    dialog --msgbox "潛行成功(靈巧-1)，找到第一塊『永恆貓鈴碎片』！(目前: $eternal_bell_fragments / 3)" 10 50
                else
                    dialog --msgbox "潛行成功(靈巧-1)，可惜這裡的碎片早被你拿走了。" 8 50
                fi
                ;;
            *)
                continue
                ;;
        esac
        break
    fi
done

show_stats

# (E) 第四章(數獄) + (F) 第五章(推理) 互動
#   => 若推理失敗(return 1)，就重玩數獄 => 直到成功
while true; do
    chapter4_sudoku        # 數獄
    chapter5_riddle       # 推理

    # 若 chapter5_riddle 回傳 1 => 答錯 => 再回來重玩數獄
    if [ $? -eq 1 ]; then
        continue
    else
        # 成功 => 結束回圈 => 進下一章
        break
    fi
done

# (G) 第六章：地下城深處(三扇門)
dialog --msgbox "$catname 來到地下城深處，這裡有三扇門：勇氣、智慧、靈巧。\n\
聽聞古老傳說，這三扇門乃是遠古時代遺留的試煉之所。\n\
每一扇門背後，都能讓選擇者提升相對應的力量。" 10 60

door_choice=$(dialog --stdout --menu "請選擇一扇門強化對應血條：" 12 50 3 \
    1 "勇氣之門(+1)" \
    2 "智慧之門(+1)" \
    3 "靈巧之門(+1)")

case $door_choice in
    1)
        courage=$((courage + 1))
        dialog --msgbox "進入勇氣之門，磨練自我(勇氣+1)" 8 50
        ;;
    2)
        wisdom=$((wisdom + 1))
        dialog --msgbox "進入智慧之門，解開藏書館的謎團(智慧+1)" 8 50
        ;;
    3)
        agility=$((agility + 1))
        dialog --msgbox "進入靈巧之門，在迷宮中身輕如燕(靈巧+1)" 8 50
        ;;
    *)
        dialog --msgbox "你放棄了強化的機會..." 5 40
        ;;
esac

show_stats

# (H) 第七章：最終決戰
dialog --msgbox "最終決戰來臨！敵人是『鼠王暗影爪』，分三階段考驗勇氣、智慧和靈巧。\n\
據古籍記載，暗影爪是老鼠國千年以來最強的君主，\n\
牠吸收了闇影之力，誓要將整個貓咪王國化為牠的領地..." 12 60

# 1) 物理攻擊 -> 勇氣 -1
dialog --msgbox "暗影爪揮出猛烈的爪擊！" 8 50
courage=$((courage - 1))
check_game_over
dialog --msgbox "你勉強擋下，但仍受傷 (勇氣-1)" 8 50

# 2) 魔法陷阱 -> 智慧 -1
dialog --msgbox "暗影爪施放魔法陷阱，空間開始扭曲！" 8 50
wisdom=$((wisdom - 1))
check_game_over
dialog --msgbox "你嘗試破解，仍受到衝擊 (智慧-1)" 8 50

# 3) 黑暗分身 -> 靈巧 -1
dialog --msgbox "暗影爪召喚出黑暗分身，動作詭譎難測！" 8 50
agility=$((agility - 1))
check_game_over
dialog --msgbox "你努力閃避，但還是被攻擊到 (靈巧-1)" 8 50

# BOSS 結果判定
if [[ $courage -gt 0 && $wisdom -gt 0 && $agility -gt 0 ]]; then
    # BOSS 被擊敗
    # 檢查是否血量≥3
    if [[ $courage -ge 3 && $wisdom -ge 3 && $agility -ge 3 ]]; then
        # 檢查是否碎片=3 => 隱藏完美結局
        if [[ $eternal_bell_fragments -eq 3 ]]; then
            dialog --msgbox "【隱藏完美結局】\n\n你在保持三條血量全滿的情況下，\n\
同時收集了三塊『永恆貓鈴碎片』！\n\n\
無毛貓先生現身，眼中閃爍著激動的淚光：\n\
『你做到了，孩子。你不僅拯救了貓咪王國，\n\
還喚醒了永恆貓鈴的真正力量！』\n\n\
隨著永恆貓鈴的完整，貓咪王國迎來了前所未有的繁榮。\n\
而你，被授予了獨一無二的榮耀稱號：\n\n『破曉之聲』！\n\n\
從此，你的名字將被永遠銘刻在貓咪王國的歷史中，\n\
成為傳說中的英雄，激勵著未來的每一代勇者貓……" 20 60
        else
            # 沒收集到3片 → 普通完美結局
            dialog --msgbox "【普通結局】\n\n你以全盛狀態擊敗了暗影爪，拯救了貓咪王國，\n\
但永恆貓鈴碎片並未完全集齊。\n\n\
無毛貓先生走到你身邊，輕聲說道：\n\
『你的勇氣與智慧令人敬佩，但永恆貓鈴的力量仍未完整。\n\
或許，王國的命運還未完全掌握在我們手中。』\n\n\
你望著手中的碎片，感受到它們散發的微弱能量，\n\
心中明白，這場冒險只是更大謎團的開始……" 20 60
        fi
    else
        # 血量不夠3
        if [[ $eternal_bell_fragments -eq 3 ]]; then
            # 已集滿碎片但血量不足 => 普通結局 + 提示可惜
            dialog --msgbox "【普通結局】\n\n你成功擊敗了暗影爪，並集齊了三塊永恆貓鈴碎片，\n\
但你的身心已在戰鬥中受到重創，無法激發碎片的全部力量。\n\n\
無毛貓先生看著你，嘆息道：\n\
『你已經做得足夠多了，孩子。碎片的能量雖未完全釋放，\n\
但它們依然為王國帶來了希望。或許有一天，\n\
會有另一位勇者貓來完成你未竟的使命。』\n\n\
你握緊手中的碎片，感受到它們微弱的光芒，\n\
心中既有成就感，也有一絲不甘。這段旅程雖有遺憾，\n\
但你知道，貓咪王國的未來依然充滿可能……" 20 60
        else
            # 普通結局
            dialog --msgbox "【普通結局】\n\n你成功擊敗了暗影爪，拯救了貓咪王國，但這場勝利並非毫無代價。\n\
你的身心在戰鬥中受到了重創，三條血條雖未完全耗盡，卻也所剩無幾。\n\n\
無毛貓先生緩緩走來，眼中帶著一絲欣慰與遺憾：\n\
『你做到了，孩子。王國得救了，但永恆貓鈴的力量並未完全恢復。\n\
或許，這正是命運的安排，讓我們明白勝利並非總是需要完美無缺。』\n\n\
你望著遠方逐漸恢復生機的貓咪王國，心中湧起複雜的情感。\n\
雖然旅程結束了，但你總覺得，還有更多的秘密等待著你去發現……" 20 60
        fi
    fi
else
    # 悲劇結局
    dialog --msgbox "【悲劇結局】\n\n你在最終決戰中失去了關鍵血量，\n\
暗影爪奪走了你的靈魂，貓咪王國亦被黑暗吞噬。\n\n\
無毛貓先生站在廢墟中，低聲呢喃：\n\
『或許，這就是命運的殘酷。但你的犧牲並不會被遺忘，\n\
你的勇氣將永遠照亮這片黑暗。』\n\n\
貓咪王國的歷史在此刻戛然而止，\n\
而你的名字，成為了傳說中的一抹悲壯色彩……" 18 60
    clear
    exit 1
fi

# 結束
dialog --msgbox "感謝遊玩《勇者貓的地下城冒險：三條血量版》！\n\nBy $team_info" 13 60
clear
exit 0
