const express = require('express');
const router = express.Router();
const chatController = require('../controllers/chatController');

// Get all conversations
router.get('/conversations', chatController.getConversations);

// Get a specific conversation
router.get('/conversations/:id', chatController.getConversation);

// Create a new conversation
router.post('/conversations', chatController.createConversation);

// Update conversation title
router.patch('/conversations/:id/title', chatController.updateConversationTitle);

// Delete a conversation
router.delete('/conversations/:id', chatController.deleteConversation);

// Send a message and get AI response
router.post('/conversations/:id/messages', chatController.sendMessage);

module.exports = router; 