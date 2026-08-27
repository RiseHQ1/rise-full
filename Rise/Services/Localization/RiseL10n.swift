//
//  RiseL10n.swift
//  Rise
//
//  Created by Rise Team on 24/08/2026.
//

import Foundation

/// Centralized localization dictionary and string translation engine for Rise.
public enum RiseL10n {
    @MainActor
    public static func tr(_ key: String) -> String {
        let lang = RiseLanguageManager.shared.currentLanguage
        return string(for: key, language: lang)
    }

    public static func string(for key: String, language: AppLanguage) -> String {
        if let langDict = strings[language], let value = langDict[key] {
            return value
        }
        return strings[.english]?[key] ?? key
    }

    private static let strings: [AppLanguage: [String: String]] = [
        .english: [
            // Tabs
            "tab.home": "Home",
            "tab.discover": "Discover",
            "tab.journal": "Journal",
            "tab.progress": "Progress",
            "tab.profile": "Profile",

            // Greetings
            "greeting.morning": "Good morning,",
            "greeting.afternoon": "Good afternoon,",
            "greeting.evening": "Good evening,",
            "greeting.tagline": "Small steps today, stronger tomorrow.",

            // Home
            "home.thought.title": "THOUGHT OF THE DAY",
            "home.intention.header": "TODAY’S INTENTION",
            "home.intention.prompt": "What’s one thing you want to accomplish today?",
            "home.intention.set": "Set Intention",
            "home.intention.update": "Update Intention",
            "home.quickActions.title": "Quick actions",
            "home.needSomething": "Need something now?",
            "action.motivate": "Motivate",
            "action.stressed": "Stressed",
            "action.focus": "Focus",
            "action.encourage": "Encourage",
            "action.eveningReflection": "Evening reflection",

            // Discover
            "discover.title": "Discover",
            "discover.searchPlaceholder": "Search affirmations, topics...",
            "discover.needHelpHeader": "What do you need right now?",
            "discover.getHelpNow": "Get help now",
            "discover.categoriesHeader": "Explore Categories",
            "discover.dailyAffirmation": "DAILY AFFIRMATION",

            // Breathing
            "breathing.title": "Breathe & Reset",
            "breathing.tagline": "Box Breathing",
            "breathing.duration": "2 min",
            "breathing.followCircle": "Follow the circle",
            "breathing.inhale": "Inhale",
            "breathing.inhalePrompt": "Inhale deeply",
            "breathing.hold": "Hold",
            "breathing.holdPrompt": "Hold gently",
            "breathing.exhale": "Exhale",
            "breathing.exhalePrompt": "Exhale slowly",
            "breathing.seconds": "seconds",

            // Journal
            "journal.title": "Daily Journal",
            "journal.subtitle": "A safe space for your thoughts, reflections, and growth.",
            "journal.feelingPrompt": "How are you feeling right now?",
            "journal.feelingSubtext": "It's okay to not be okay.",
            "journal.pastEntries": "Past entries",
            "journal.newEntry": "New Entry",
            "journal.save": "Save",
            "journal.saveEntry": "Save Entry",
            "journal.deleteEntry": "Delete Entry",
            "journal.writeFreely": "Start writing freely... There are no right or wrong answers.",
            "feeling.great": "Great",
            "feeling.calm": "Calm",
            "feeling.okay": "Okay",
            "feeling.low": "Low",
            "feeling.tired": "Tired",

            // Progress
            "progress.title": "Your Progress",
            "progress.consistency": "Weekly Consistency",
            "progress.streak": "Current Streak",
            "progress.days": "days",
            "progress.totalReflections": "Total Reflections",
            "progress.mindfulMinutes": "Mindful Minutes",
            "progress.monthlyGrowth": "Monthly Growth",
            "progress.focusAreas": "Focus Areas",
            "progress.manage": "Manage",

            // Profile & Settings
            "profile.title": "Profile",
            "profile.yourPlan": "Your Rise Plan",
            "profile.editQuote": "Edit Quote",
            "profile.preferences": "Preferences",
            "profile.language": "Language",
            "profile.chooseLanguage": "Choose your language.",
            "profile.saveLanguage": "Save Language",
            "profile.notifications": "Notifications",
            "profile.reminderSchedule": "Reminder Schedule",
            "profile.privacySecurity": "Privacy & Security",
            "profile.backupRestore": "Backup & Restore",
            "profile.signOut": "Sign Out",
            "profile.theme": "Theme",

            // Motivation & Audio
            "motivation.morningBoost": "Morning Boost",
            "motivation.listen": "Listen to this",
            "motivation.letSinkIn": "Let these words sink in.",
            "motivation.playing": "Playing",

            // Common
            "common.cancel": "Cancel",
            "common.back": "Back",
            "common.done": "Done",
            "common.save": "Save",
            "common.share": "Share",
            "common.seeAll": "See all",
        ],

        .spanish: [
            // Tabs
            "tab.home": "Inicio",
            "tab.discover": "Descubrir",
            "tab.journal": "Diario",
            "tab.progress": "Progreso",
            "tab.profile": "Perfil",

            // Greetings
            "greeting.morning": "Buenos días,",
            "greeting.afternoon": "Buenas tardes,",
            "greeting.evening": "Buenas noches,",
            "greeting.tagline": "Pequeños pasos hoy, más fuerte mañana.",

            // Home
            "home.thought.title": "PENSAMIENTO DEL DÍA",
            "home.intention.header": "INTENCIÓN DE HOY",
            "home.intention.prompt": "¿Qué quieres lograr el día de hoy?",
            "home.intention.set": "Fijar Intención",
            "home.intention.update": "Actualizar Intención",
            "home.quickActions.title": "Acciones rápidas",
            "home.needSomething": "¿Necesitas algo ahora?",
            "action.motivate": "Motivar",
            "action.stressed": "Estrés",
            "action.focus": "Enfoque",
            "action.encourage": "Ánimo",
            "action.eveningReflection": "Reflexión nocturna",

            // Discover
            "discover.title": "Descubrir",
            "discover.searchPlaceholder": "Buscar afirmaciones, temas...",
            "discover.needHelpHeader": "¿Qué necesitas en este momento?",
            "discover.getHelpNow": "Obtener ayuda ahora",
            "discover.categoriesHeader": "Explorar Categorías",
            "discover.dailyAffirmation": "AFIRMACIÓN DIARIA",

            // Breathing
            "breathing.title": "Respira y Reinicia",
            "breathing.tagline": "Respiración Cuadrada",
            "breathing.duration": "2 min",
            "breathing.followCircle": "Sigue el círculo",
            "breathing.inhale": "Inhala",
            "breathing.inhalePrompt": "Inhala profundamente",
            "breathing.hold": "Sostén",
            "breathing.holdPrompt": "Sostén suavemente",
            "breathing.exhale": "Exhala",
            "breathing.exhalePrompt": "Exhala despacio",
            "breathing.seconds": "segundos",

            // Journal
            "journal.title": "Diario Personal",
            "journal.subtitle": "Un espacio seguro para tus pensamientos, reflexiones y crecimiento.",
            "journal.feelingPrompt": "¿Cómo te sientes ahora mismo?",
            "journal.feelingSubtext": "Está bien no estar bien.",
            "journal.pastEntries": "Entradas anteriores",
            "journal.newEntry": "Nueva Entrada",
            "journal.save": "Guardar",
            "journal.saveEntry": "Guardar Entrada",
            "journal.deleteEntry": "Eliminar Entrada",
            "journal.writeFreely": "Escribe con total libertad... No hay respuestas incorrectas.",
            "feeling.great": "Genial",
            "feeling.calm": "Calma",
            "feeling.okay": "Bien",
            "feeling.low": "Bajo",
            "feeling.tired": "Cansado",

            // Progress
            "progress.title": "Tu Progreso",
            "progress.consistency": "Consistencia Semanal",
            "progress.streak": "Racha Actual",
            "progress.days": "días",
            "progress.totalReflections": "Reflexiones Totales",
            "progress.mindfulMinutes": "Minutos Conscientes",
            "progress.monthlyGrowth": "Crecimiento Mensual",
            "progress.focusAreas": "Áreas de Enfoque",
            "progress.manage": "Gestionar",

            // Profile & Settings
            "profile.title": "Perfil",
            "profile.yourPlan": "Tu Plan Rise",
            "profile.editQuote": "Editar Frase",
            "profile.preferences": "Preferencias",
            "profile.language": "Idioma",
            "profile.chooseLanguage": "Elige tu idioma.",
            "profile.saveLanguage": "Guardar Idioma",
            "profile.notifications": "Notificaciones",
            "profile.reminderSchedule": "Horario de Recordatorios",
            "profile.privacySecurity": "Privacidad y Seguridad",
            "profile.backupRestore": "Copia de Seguridad y Restauración",
            "profile.signOut": "Cerrar Sesión",
            "profile.theme": "Tema",

            // Motivation & Audio
            "motivation.morningBoost": "Impulso Matutino",
            "motivation.listen": "Escucha esto",
            "motivation.letSinkIn": "Deja que estas palabras calen hondo.",
            "motivation.playing": "Reproduciendo",

            // Common
            "common.cancel": "Cancelar",
            "common.back": "Atrás",
            "common.done": "Hecho",
            "common.save": "Guardar",
            "common.share": "Compartir",
            "common.seeAll": "Ver todo",
        ],

        .french: [
            // Tabs
            "tab.home": "Accueil",
            "tab.discover": "Découvrir",
            "tab.journal": "Journal",
            "tab.progress": "Progrès",
            "tab.profile": "Profil",

            // Greetings
            "greeting.morning": "Bonjour,",
            "greeting.afternoon": "Bon après-midi,",
            "greeting.evening": "Bonsoir,",
            "greeting.tagline": "Petits pas aujourd'hui, plus fort demain.",

            // Home
            "home.thought.title": "PENSÉE DU JOUR",
            "home.intention.header": "INTENTION DU JOUR",
            "home.intention.prompt": "Que souhaitez-vous accomplir aujourd'hui ?",
            "home.intention.set": "Définir l'Intention",
            "home.intention.update": "Modifier l'Intention",
            "home.quickActions.title": "Actions rapides",
            "home.needSomething": "Besoin d'aide maintenant ?",
            "action.motivate": "Motiver",
            "action.stressed": "Stressé",
            "action.focus": "Concentration",
            "action.encourage": "Encourager",
            "action.eveningReflection": "Réflexion du soir",

            // Discover
            "discover.title": "Découvrir",
            "discover.searchPlaceholder": "Rechercher affirmations, thèmes...",
            "discover.needHelpHeader": "De quoi avez-vous besoin maintenant ?",
            "discover.getHelpNow": "Obtenir de l'aide",
            "discover.categoriesHeader": "Explorer les Catégories",
            "discover.dailyAffirmation": "AFFIRMATION QUOTIDIENNE",

            // Breathing
            "breathing.title": "Respirer et Réinitialiser",
            "breathing.tagline": "Respiration Carrée",
            "breathing.duration": "2 min",
            "breathing.followCircle": "Suivez le cercle",
            "breathing.inhale": "Inspirez",
            "breathing.inhalePrompt": "Inspirez profondément",
            "breathing.hold": "Retenez",
            "breathing.holdPrompt": "Retenez doucement",
            "breathing.exhale": "Expirez",
            "breathing.exhalePrompt": "Expirez lentement",
            "breathing.seconds": "secondes",

            // Journal
            "journal.title": "Journal Quotidien",
            "journal.subtitle": "Un espace sûr pour vos pensées, réflexions et évolution.",
            "journal.feelingPrompt": "Comment vous sentez-vous en ce moment ?",
            "journal.feelingSubtext": "C'est normal de ne pas toujours aller bien.",
            "journal.pastEntries": "Entrées passées",
            "journal.newEntry": "Nouvelle Entrée",
            "journal.save": "Enregistrer",
            "journal.saveEntry": "Enregistrer l'Entrée",
            "journal.deleteEntry": "Supprimer l'Entrée",
            "journal.writeFreely": "Écrivez librement... Il n'y a pas de mauvaise réponse.",
            "feeling.great": "Super",
            "feeling.calm": "Calme",
            "feeling.okay": "Bien",
            "feeling.low": "Bas",
            "feeling.tired": "Fatigué",

            // Progress
            "progress.title": "Votre Progrès",
            "progress.consistency": "Régularité Hebdomadaire",
            "progress.streak": "Série Actuelle",
            "progress.days": "jours",
            "progress.totalReflections": "Réflexions Totales",
            "progress.mindfulMinutes": "Minutes Conscientes",
            "progress.monthlyGrowth": "Croissance Mensuelle",
            "progress.focusAreas": "Domaines Clés",
            "progress.manage": "Gérer",

            // Profile & Settings
            "profile.title": "Profil",
            "profile.yourPlan": "Votre Programme Rise",
            "profile.editQuote": "Modifier la Citation",
            "profile.preferences": "Préférences",
            "profile.language": "Langue",
            "profile.chooseLanguage": "Choisissez votre langue.",
            "profile.saveLanguage": "Enregistrer la Langue",
            "profile.notifications": "Notifications",
            "profile.reminderSchedule": "Horaires des Rappels",
            "profile.privacySecurity": "Confidentialité et Sécurité",
            "profile.backupRestore": "Sauvegarde et Restauration",
            "profile.signOut": "Se Déconnecter",
            "profile.theme": "Thème",

            // Motivation & Audio
            "motivation.morningBoost": "Boost Matinal",
            "motivation.listen": "Écoutez ceci",
            "motivation.letSinkIn": "Laissez ces mots résonner en vous.",
            "motivation.playing": "Lecture en cours",

            // Common
            "common.cancel": "Annuler",
            "common.back": "Retour",
            "common.done": "Terminé",
            "common.save": "Enregistrer",
            "common.share": "Partager",
            "common.seeAll": "Voir tout",
        ],

        .german: [
            // Tabs
            "tab.home": "Start",
            "tab.discover": "Entdecken",
            "tab.journal": "Tagebuch",
            "tab.progress": "Fortschritt",
            "tab.profile": "Profil",

            // Greetings
            "greeting.morning": "Guten Morgen,",
            "greeting.afternoon": "Guten Tag,",
            "greeting.evening": "Guten Abend,",
            "greeting.tagline": "Kleine Schritte heute, stärker morgen.",

            // Home
            "home.thought.title": "GEDANKE DES TAGES",
            "home.intention.header": "HEUTIGE INTENTION",
            "home.intention.prompt": "Was möchtest du heute erreichen?",
            "home.intention.set": "Intention setzen",
            "home.intention.update": "Intention bearbeiten",
            "home.quickActions.title": "Schnellaktionen",
            "home.needSomething": "Brauchst du jetzt Unterstützung?",
            "action.motivate": "Motivieren",
            "action.stressed": "Gestresst",
            "action.focus": "Fokus",
            "action.encourage": "Ermutigen",
            "action.eveningReflection": "Abendreflexion",

            // Discover
            "discover.title": "Entdecken",
            "discover.searchPlaceholder": "Affirmationen und Themen suchen...",
            "discover.needHelpHeader": "Was brauchst du gerade?",
            "discover.getHelpNow": "Jetzt Hilfe erhalten",
            "discover.categoriesHeader": "Kategorien erkunden",
            "discover.dailyAffirmation": "TÄGLICHE AFFIRMATION",

            // Breathing
            "breathing.title": "Atmen & Zurücksetzen",
            "breathing.tagline": "Box-Atmung",
            "breathing.duration": "2 Min",
            "breathing.followCircle": "Folge dem Kreis",
            "breathing.inhale": "Einatmen",
            "breathing.inhalePrompt": "Tief einatmen",
            "breathing.hold": "Halten",
            "breathing.holdPrompt": "Sanft anhalten",
            "breathing.exhale": "Ausatmen",
            "breathing.exhalePrompt": "Langsam ausatmen",
            "breathing.seconds": "Sekunden",

            // Journal
            "journal.title": "Tägliches Tagebuch",
            "journal.subtitle": "Ein geschützter Raum für deine Gedanken und dein Wachstum.",
            "journal.feelingPrompt": "Wie fühlst du dich gerade?",
            "journal.feelingSubtext": "Es ist in Ordnung, sich nicht gut zu fühlen.",
            "journal.pastEntries": "Frühere Einträge",
            "journal.newEntry": "Neuer Eintrag",
            "journal.save": "Speichern",
            "journal.saveEntry": "Eintrag speichern",
            "journal.deleteEntry": "Eintrag löschen",
            "journal.writeFreely": "Schreibe frei von der Seele weg... Es gibt kein Richtig oder Falsch.",
            "feeling.great": "Großartig",
            "feeling.calm": "Ruhig",
            "feeling.okay": "Okay",
            "feeling.low": "Gedrückt",
            "feeling.tired": "Müde",

            // Progress
            "progress.title": "Dein Fortschritt",
            "progress.consistency": "Wöchentliche Beständigkeit",
            "progress.streak": "Aktuelle Serie",
            "progress.days": "Tage",
            "progress.totalReflections": "Gesamte Reflexionen",
            "progress.mindfulMinutes": "Achtsame Minuten",
            "progress.monthlyGrowth": "Monatliches Wachstum",
            "progress.focusAreas": "Fokusbereiche",
            "progress.manage": "Verwalten",

            // Profile & Settings
            "profile.title": "Profil",
            "profile.yourPlan": "Dein Rise-Plan",
            "profile.editQuote": "Zitat bearbeiten",
            "profile.preferences": "Einstellungen",
            "profile.language": "Sprache",
            "profile.chooseLanguage": "Wähle deine Sprache.",
            "profile.saveLanguage": "Sprache speichern",
            "profile.notifications": "Benachrichtigungen",
            "profile.reminderSchedule": "Erinnerungsplan",
            "profile.privacySecurity": "Datenschutz & Sicherheit",
            "profile.backupRestore": "Sicherung & Wiederherstellung",
            "profile.signOut": "Abmelden",
            "profile.theme": "Design",

            // Motivation & Audio
            "motivation.morningBoost": "Morgen-Boost",
            "motivation.listen": "Höre dir das an",
            "motivation.letSinkIn": "Lass diese Worte auf dich wirken.",
            "motivation.playing": "Wird abgespielt",

            // Common
            "common.cancel": "Abbrechen",
            "common.back": "Zurück",
            "common.done": "Fertig",
            "common.save": "Speichern",
            "common.share": "Teilen",
            "common.seeAll": "Alle anzeigen",
        ],

        .portuguese: [
            // Tabs
            "tab.home": "Início",
            "tab.discover": "Descobrir",
            "tab.journal": "Diário",
            "tab.progress": "Progresso",
            "tab.profile": "Perfil",

            // Greetings
            "greeting.morning": "Bom dia,",
            "greeting.afternoon": "Boa tarde,",
            "greeting.evening": "Boa noite,",
            "greeting.tagline": "Pequenos passos hoje, mais forte amanhã.",

            // Home
            "home.thought.title": "PENSAMENTO DO DIA",
            "home.intention.header": "INTENÇÃO DE HOJE",
            "home.intention.prompt": "O que você quer realizar hoje?",
            "home.intention.set": "Definir Intenção",
            "home.intention.update": "Atualizar Intenção",
            "home.quickActions.title": "Ações rápidas",
            "home.needSomething": "Precisa de algo agora?",
            "action.motivate": "Motivar",
            "action.stressed": "Estresse",
            "action.focus": "Foco",
            "action.encourage": "Encorajar",
            "action.eveningReflection": "Reflexão da noite",

            // Discover
            "discover.title": "Descobrir",
            "discover.searchPlaceholder": "Buscar afirmações, tópicos...",
            "discover.needHelpHeader": "Do que você precisa agora?",
            "discover.getHelpNow": "Obter ajuda agora",
            "discover.categoriesHeader": "Explorar Categorias",
            "discover.dailyAffirmation": "AFIRMAÇÃO DIÁRIA",

            // Breathing
            "breathing.title": "Respirar e Reiniciar",
            "breathing.tagline": "Respiração Quadrada",
            "breathing.duration": "2 min",
            "breathing.followCircle": "Siga o círculo",
            "breathing.inhale": "Inspire",
            "breathing.inhalePrompt": "Inspire profundamente",
            "breathing.hold": "Segure",
            "breathing.holdPrompt": "Segure suavemente",
            "breathing.exhale": "Expire",
            "breathing.exhalePrompt": "Expire devagar",
            "breathing.seconds": "segundos",

            // Journal
            "journal.title": "Diário Pessoal",
            "journal.subtitle": "Um espaço seguro para seus pensamentos, reflexões e evolução.",
            "journal.feelingPrompt": "Como você está se sentindo agora?",
            "journal.feelingSubtext": "Tudo bem não estar bem.",
            "journal.pastEntries": "Entradas anteriores",
            "journal.newEntry": "Nova Entrada",
            "journal.save": "Salvar",
            "journal.saveEntry": "Salvar Entrada",
            "journal.deleteEntry": "Excluir Entrada",
            "journal.writeFreely": "Escreva livremente... Não existem respostas erradas.",
            "feeling.great": "Ótimo",
            "feeling.calm": "Calmo",
            "feeling.okay": "Bem",
            "feeling.low": "Desanimado",
            "feeling.tired": "Cansado",

            // Progress
            "progress.title": "Seu Progresso",
            "progress.consistency": "Consistência Semanal",
            "progress.streak": "Sequência Atual",
            "progress.days": "dias",
            "progress.totalReflections": "Total de Reflexões",
            "progress.mindfulMinutes": "Minutos Conscientes",
            "progress.monthlyGrowth": "Crescimento Mensal",
            "progress.focusAreas": "Áreas de Foco",
            "progress.manage": "Gerenciar",

            // Profile & Settings
            "profile.title": "Perfil",
            "profile.yourPlan": "Seu Plano Rise",
            "profile.editQuote": "Editar Frase",
            "profile.preferences": "Preferências",
            "profile.language": "Idioma",
            "profile.chooseLanguage": "Escolha seu idioma.",
            "profile.saveLanguage": "Salvar Idioma",
            "profile.notifications": "Notificações",
            "profile.reminderSchedule": "Horário de Lembretes",
            "profile.privacySecurity": "Privacidade e Segurança",
            "profile.backupRestore": "Backup e Restauração",
            "profile.signOut": "Sair",
            "profile.theme": "Tema",

            // Motivation & Audio
            "motivation.morningBoost": "Impulso Matinal",
            "motivation.listen": "Ouça isto",
            "motivation.letSinkIn": "Deixe essas palavras ressoarem em você.",
            "motivation.playing": "Tocando",

            // Common
            "common.cancel": "Cancelar",
            "common.back": "Voltar",
            "common.done": "Concluído",
            "common.save": "Salvar",
            "common.share": "Compartilhar",
            "common.seeAll": "Ver tudo",
        ],

        .arabic: [
            // Tabs
            "tab.home": "الرئيسية",
            "tab.discover": "اكتشف",
            "tab.journal": "المذكرات",
            "tab.progress": "التقدم",
            "tab.profile": "الملف الشخصي",

            // Greetings
            "greeting.morning": "صباح الخير،",
            "greeting.afternoon": "مساء الخير،",
            "greeting.evening": "مساء النور،",
            "greeting.tagline": "خطوات صغيرة اليوم تصنع غداً أقوى.",

            // Home
            "home.thought.title": "فكرة اليوم",
            "home.intention.header": "نية اليوم",
            "home.intention.prompt": "ما هو الشيء الذي تريد إنجازه اليوم؟",
            "home.intention.set": "تحديد النية",
            "home.intention.update": "تحديث النية",
            "home.quickActions.title": "إجراءات سريعة",
            "home.needSomething": "هل تحتاج إلى مساعدة الآن؟",
            "action.motivate": "تحفيز",
            "action.stressed": "توتر",
            "action.focus": "تركيز",
            "action.encourage": "تشجيع",
            "action.eveningReflection": "تأمل المساء",

            // Discover
            "discover.title": "اكتشف",
            "discover.searchPlaceholder": "ابحث عن التوكيدات والمواضيع...",
            "discover.needHelpHeader": "ماذا تحتاج في هذه اللحظة؟",
            "discover.getHelpNow": "احصل على المساعدة الآن",
            "discover.categoriesHeader": "استكشف الفئات",
            "discover.dailyAffirmation": "التوكيد اليومي",

            // Breathing
            "breathing.title": "تنفس واستعد توازنك",
            "breathing.tagline": "تنفس المربع",
            "breathing.duration": "دقيقتان",
            "breathing.followCircle": "اتبع الدائرة",
            "breathing.inhale": "شهيق",
            "breathing.inhalePrompt": "خذ شهيقاً عميقاً",
            "breathing.hold": "احبس النفس",
            "breathing.holdPrompt": "اهدأ واحبس النفس",
            "breathing.exhale": "زفير",
            "breathing.exhalePrompt": "أخرج الزفير ببطء",
            "breathing.seconds": "ثوانٍ",

            // Journal
            "journal.title": "المذكرات اليومية",
            "journal.subtitle": "مساحة آمنة لأفكارك وتأملاتك ونموك الشخصي.",
            "journal.feelingPrompt": "كيف تشعر في هذه اللحظة؟",
            "journal.feelingSubtext": "من الطبيعي ألا تكون على ما يرام دائماً.",
            "journal.pastEntries": "المذكرات السابقة",
            "journal.newEntry": "مذكرة جديدة",
            "journal.save": "حفظ",
            "journal.saveEntry": "حفظ المذكرة",
            "journal.deleteEntry": "حذف المذكرة",
            "journal.writeFreely": "اكتب بكل حرية... لا توجد إجابات صحيحة أو خاطئة.",
            "feeling.great": "رائع",
            "feeling.calm": "هادئ",
            "feeling.okay": "جيد",
            "feeling.low": "محبط",
            "feeling.tired": "متعب",

            // Progress
            "progress.title": "تقدمك",
            "progress.consistency": "الاستمرارية الأسبوعية",
            "progress.streak": "السلسلة الحالية",
            "progress.days": "أيام",
            "progress.totalReflections": "إجمالي التأملات",
            "progress.mindfulMinutes": "دقائق اليقظة",
            "progress.monthlyGrowth": "النمو الشهري",
            "progress.focusAreas": "مجالات التركيز",
            "progress.manage": "إدارة",

            // Profile & Settings
            "profile.title": "الملف الشخصي",
            "profile.yourPlan": "خطتك في Rise",
            "profile.editQuote": "تعديل الاقتباس",
            "profile.preferences": "التفضيلات",
            "profile.language": "اللغة",
            "profile.chooseLanguage": "اختر لغتك المفضلة.",
            "profile.saveLanguage": "حفظ اللغة",
            "profile.notifications": "الإشعارات",
            "profile.reminderSchedule": "جدول التذكيرات",
            "profile.privacySecurity": "الخصوصية والأمان",
            "profile.backupRestore": "النسخ الاحتياطي والاستعادة",
            "profile.signOut": "تسجيل الخروج",
            "profile.theme": "المظهر",

            // Motivation & Audio
            "motivation.morningBoost": "دفعة الصباح",
            "motivation.listen": "استمع إلى هذا",
            "motivation.letSinkIn": "دع هذه الكلمات تلامس قلبك.",
            "motivation.playing": "قيد التشغيل",

            // Common
            "common.cancel": "إلغاء",
            "common.back": "رجوع",
            "common.done": "تم",
            "common.save": "حفظ",
            "common.share": "مشاركة",
            "common.seeAll": "عرض الكل",
        ],
    ]
}
