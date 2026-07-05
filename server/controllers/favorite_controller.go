package controllers

import (
	"fmt"
	"net/http"
	"strconv"
	"telegram-server/db"
	"telegram-server/models"
	"telegram-server/utils"

	"github.com/gin-gonic/gin"
)

// FavoriteController 收藏控制器
type FavoriteController struct {
	favoriteRepo *models.FavoriteRepository
}

// NewFavoriteController 创建收藏控制器实例
func NewFavoriteController() *FavoriteController {
	favoriteRepo := models.NewFavoriteRepository(db.DB)
	return &FavoriteController{
		favoriteRepo: favoriteRepo,
	}
}

// GetFavorites 获取收藏列表（分页）
// GET /api/favorites?page=1&page_size=20
func (ctrl *FavoriteController) GetFavorites(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"code": 401, "message": "未授权"})
		return
	}

	// 获取分页参数
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	pageSize, _ := strconv.Atoi(c.DefaultQuery("page_size", "20"))

	// 参数验证
	if page < 1 {
		page = 1
	}
	if pageSize < 1 || pageSize > 100 {
		pageSize = 20
	}

	// 查询收藏列表
	favorites, total, err := ctrl.favoriteRepo.GetByUserID(userID.(int), page, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"code": 500, "message": "获取收藏列表失败"})
		return
	}

	// 计算总页数
	totalPages := (total + pageSize - 1) / pageSize

	c.JSON(http.StatusOK, gin.H{
		"code":    0,
		"message": "获取成功",
		"data": gin.H{
			"favorites":   favorites,
			"total":       total,
			"page":        page,
			"page_size":   pageSize,
			"total_pages": totalPages,
		},
	})
}

// DeleteFavorite 删除收藏
// DELETE /api/favorites/:id
func (ctrl *FavoriteController) DeleteFavorite(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"code": 401, "message": "未授权"})
		return
	}

	favoriteID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"code": 400, "message": "无效的收藏ID"})
		return
	}

	err = ctrl.favoriteRepo.Delete(favoriteID, userID.(int))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"code": 500, "message": "删除收藏失败"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"code":    0,
		"message": "删除成功",
	})
}

// CreateDirectFavorite 直接创建收藏（不需要message_id，用于群组消息等）
// POST /api/favorites/direct
func (ctrl *FavoriteController) CreateDirectFavorite(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"code": 401, "message": "未授权"})
		return
	}

	var req struct {
		Content     string  `json:"content" binding:"required"`
		MessageType string  `json:"message_type" binding:"required"`
		FileName    *string `json:"file_name"`
		SenderID    int     `json:"sender_id" binding:"required"`
		SenderName  string  `json:"sender_name" binding:"required"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"code": 400, "message": "请求参数错误"})
		return
	}

	// 检查是否已收藏（通过内容、发送者ID和用户ID）
	exists2, favoriteID, checkErr := ctrl.favoriteRepo.CheckExistsByContent(userID.(int), req.Content, req.SenderID)
	if checkErr != nil {
		utils.LogError("检查收藏状态失败 (user_id: %d, sender_id: %d): %v", userID.(int), req.SenderID, checkErr)
		c.JSON(http.StatusInternalServerError, gin.H{"code": 500, "message": "检查收藏状态失败"})
		return
	}

	if exists2 {
		// 如果已收藏，更新创建时间
		utils.LogDebug("消息已收藏，更新创建时间 - user_id: %d, favorite_id: %d", userID.(int), favoriteID)
		updatedFavorite, updateErr := ctrl.favoriteRepo.UpdateCreatedAt(favoriteID, userID.(int))
		if updateErr != nil {
			utils.LogError("更新收藏时间失败 (favorite_id: %d): %v", favoriteID, updateErr)
			c.JSON(http.StatusInternalServerError, gin.H{"code": 500, "message": "更新收藏时间失败"})
			return
		}
		c.JSON(http.StatusOK, gin.H{
			"code":    0,
			"message": "已更新收藏时间",
			"data":    updatedFavorite,
		})
		return
	}

	// 创建收藏（message_id 为 NULL）
	favorite, err := ctrl.favoriteRepo.Create(
		userID.(int),
		nil, // message_id 为 null
		req.Content,
		req.MessageType,
		req.FileName,
		req.SenderID,
		req.SenderName,
	)

	if err != nil {
		utils.LogError("创建收藏失败 (user_id: %d): %v", userID.(int), err)
		c.JSON(http.StatusInternalServerError, gin.H{"code": 500, "message": fmt.Sprintf("收藏失败: %v", err)})
		return
	}

	utils.LogDebug("直接创建收藏成功 - favorite_id: %d, user_id: %d", favorite.ID, userID.(int))

	c.JSON(http.StatusOK, gin.H{
		"code":    0,
		"message": "已保存到收藏夹",
		"data":    favorite,
	})
}
