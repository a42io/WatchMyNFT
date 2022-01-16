module.exports = {
    parserOptions: {
        project: 'tsconfig.json',
        sourceType: 'module'
    },
    env: {
        browser: true,
    },
    parser: '@typescript-eslint/parser',
    plugins: ['@typescript-eslint', 'prettier'],
    extends: [
        'plugin:@typescript-eslint/recommended',
        'plugin:prettier/recommended',
        'prettier'
    ],
    rules: {
        '@typescript-eslint/no-empty-function': ['off'],
        '@typescript-eslint/explicit-module-boundary-types': 'off',
        "@typescript-eslint/no-unused-vars": [
            "error",
            { "varsIgnorePattern": "_", "argsIgnorePattern": "_" }
        ],
        '@typescript-eslint/ban-types': [
            'error',
            {
                'extendDefaults': true,
                'types': {
                    '{}': false
                }
            }
        ]
    }
}
